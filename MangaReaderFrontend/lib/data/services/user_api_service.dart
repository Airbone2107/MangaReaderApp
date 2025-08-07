import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/app_config.dart'; // Import config
import '../../utils/logger.dart';
import '../models/user_model.dart';
import '../storage/secure_storage_service.dart';

class UserApiService {
  final String baseUrl;
  final http.Client client;

  // Sử dụng AppConfig.baseUrl làm giá trị mặc định
  UserApiService({
    this.baseUrl = AppConfig.baseUrl,
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<void> signInWithGoogle(GoogleSignInAccount googleUser) async {
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      logger.d('Authenticating with Google...');

      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        throw Exception('Không lấy được idToken từ Google');
      }

      logger.d('idToken available, sending to backend...');

      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/auth/google'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{'idToken': idToken}),
      );

      logger.d('Response status: ${response.statusCode}');
      logger.t('Response body: ${response.body}'); // Use trace for full body

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        final String backendToken = data['token'] as String;
        await SecureStorageService.saveToken(backendToken);
        logger.i('Đăng nhập thành công. Token từ backend đã được lưu.');
      } else {
        throw HttpException(
            'Đăng nhập thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e, s) {
      logger.e('Lỗi trong signInWithGoogle', error: e, stackTrace: s);
      throw Exception('Lỗi đăng nhập: $e');
    }
  }

  Future<void> logout() async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        return;
      }

      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/logout'),
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        await SecureStorageService.removeToken();
        logger.i('Đăng xuất thành công.');
      } else {
        throw const HttpException('Đăng xuất thất bại');
      }
    } catch (e, s) {
      logger.e('Lỗi khi đăng xuất', error: e, stackTrace: s);
      throw Exception('Lỗi khi đăng xuất: $e');
    }
  }

  Future<User> getUserData() async {
    final String token = await _getTokenOrThrow();
    logger.d('getUserData đang xử lý...');

    final http.Response response = await client.get(
      Uri.parse('$baseUrl/api/users'),
      headers: _buildHeaders(token),
    );

    if (response.statusCode == 200) {
      logger.i('Lấy dữ liệu người dùng thành công.');
      final Map<String, dynamic> userData =
          jsonDecode(response.body) as Map<String, dynamic>;
      return User.fromJson(userData);
    } else if (response.statusCode == 403) {
      logger
          .w('Lỗi 403 - Forbidden. Token có thể đã hết hạn hoặc không hợp lệ.');
      throw const HttpException('403');
    } else {
      logger.e('Không thể lấy thông tin user. Mã lỗi: ${response.statusCode}',
          error: response.body);
      throw HttpException(
          'Không thể lấy thông tin user. Mã lỗi: ${response.statusCode}');
    }
  }

  Future<void> addToFollowing(String mangaId) async {
    final String token = await _getTokenOrThrow();
    try {
      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/follow'),
        headers: _buildHeaders(token),
        body: jsonEncode(<String, String>{'mangaId': mangaId}),
      );
      if (response.statusCode != 200) {
        final Map<String, dynamic> error =
            jsonDecode(response.body) as Map<String, dynamic>;
        logger.w('Không thể thêm vào danh sách theo dõi', error: error);
        throw HttpException((error['message'] as String?) ??
            'Không thể thêm vào danh sách theo dõi');
      }
      logger.i('Đã thêm manga $mangaId vào danh sách theo dõi.');
    } catch (e, s) {
      logger.e('Lỗi trong addToFollowing', error: e, stackTrace: s);
      throw Exception('Lỗi khi thêm manga: $e');
    }
  }

  Future<void> removeFromFollowing(String mangaId) async {
    final String token = await _getTokenOrThrow();
    try {
      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/unfollow'),
        headers: _buildHeaders(token),
        body: jsonEncode(<String, String>{'mangaId': mangaId}),
      );
      if (response.statusCode != 200) {
        final Map<String, dynamic> error =
            jsonDecode(response.body) as Map<String, dynamic>;
        logger.w('Không thể bỏ theo dõi truyện', error: error);
        throw HttpException(
            (error['message'] as String?) ?? 'Không thể bỏ theo dõi truyện');
      }
      logger.i('Đã bỏ theo dõi manga $mangaId.');
    } catch (e, s) {
      logger.e('Lỗi trong removeFromFollowing', error: e, stackTrace: s);
      throw Exception('Lỗi khi bỏ theo dõi: $e');
    }
  }

  Future<bool> checkIfUserIsFollowing(String mangaId) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        return false;
      }
      final http.Response response = await http.get(
        Uri.parse('$baseUrl/api/users/user/following/$mangaId'),
        headers: _buildHeaders(token),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            jsonDecode(response.body) as Map<String, dynamic>;
        return body['isFollowing'] as bool? ?? false;
      } else {
        logger.w('Lỗi khi kiểm tra theo dõi',
            error: 'Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Lỗi khi kiểm tra theo dõi: ${response.body}');
      }
    } catch (e, s) {
      logger.e('Lỗi nghiêm trọng khi kiểm tra trạng thái theo dõi',
          error: e, stackTrace: s);
      return false;
    }
  }

  Future<void> updateReadingProgress(String mangaId, String lastChapter) async {
    final String token = await _getTokenOrThrow();
    try {
      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/reading-progress'),
        headers: _buildHeaders(token),
        body: jsonEncode(<String, String>{
          'mangaId': mangaId,
          'lastChapter': lastChapter,
        }),
      );
      if (response.statusCode != 200) {
        final Map<String, dynamic> error =
            jsonDecode(response.body) as Map<String, dynamic>;
        logger.w('Không thể cập nhật tiến độ đọc', error: error);
        throw HttpException(
            (error['message'] as String?) ?? 'Không thể cập nhật tiến độ đọc');
      }
      logger.i(
          'Đã cập nhật tiến độ đọc cho manga $mangaId, chapter $lastChapter');
    } catch (e, s) {
      logger.e('Lỗi trong updateReadingProgress', error: e, stackTrace: s);
      throw Exception('Lỗi khi cập nhật tiến độ: $e');
    }
  }

  Map<String, String> _buildHeaders(String token) {
    return <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String> _getTokenOrThrow() async {
    final String? token = await SecureStorageService.getToken();
    if (token == null) {
      logger.w('Không tìm thấy token. Yêu cầu đăng nhập.');
      throw const HttpException('Không tìm thấy token');
    }
    return token;
  }

  void dispose() {
    client.close();
  }
}
