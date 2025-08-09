import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/app_config.dart';
import '../../utils/logger.dart';
import '../models/user_model.dart';
import '../storage/secure_storage_service.dart';

/// Service tương tác với backend cho các nghiệp vụ người dùng.
///
/// - Đăng nhập Google và lưu token
/// - Đăng xuất
/// - Lấy thông tin người dùng
/// - Theo dõi/Bỏ theo dõi manga
/// - Kiểm tra trạng thái theo dõi
/// - Cập nhật tiến độ đọc
class UserApiService {
  final String baseUrl;
  final http.Client client;

  /// Khởi tạo với `AppConfig.baseUrl` làm mặc định nếu không chỉ định `baseUrl`.
  UserApiService({this.baseUrl = AppConfig.baseUrl, http.Client? client})
    : client = client ?? http.Client();

  // --- NEW: Email/Password Methods ---

  /// Đăng ký tài khoản mới bằng email.
  Future<String> register(String displayName, String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/users/register'),
      headers: _buildHeaders(null),
      body: jsonEncode({
        'displayName': displayName,
        'email': email,
        'password': password,
      }),
    );

    final dynamic body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body['message'] as String;
    } else {
      throw HttpException((body['message'] as String?) ?? 'Đăng ký thất bại');
    }
  }

  /// Đăng nhập bằng email và mật khẩu.
  Future<void> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/users/login'),
      headers: _buildHeaders(null),
      body: jsonEncode({'email': email, 'password': password}),
    );

    final dynamic body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final String backendToken = body['token'] as String;
      await SecureStorageService.saveToken(backendToken);
      logger.i('Đăng nhập bằng email thành công.');
    } else {
      throw HttpException((body['message'] as String?) ?? 'Đăng nhập thất bại');
    }
  }

  /// Gửi yêu cầu quên mật khẩu.
  Future<String> forgotPassword(String email) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/users/forgot-password'),
      headers: _buildHeaders(null),
      body: jsonEncode({'email': email}),
    );
    
    final dynamic body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return body['message'] as String;
    } else {
      throw HttpException((body['message'] as String?) ?? 'Yêu cầu quên mật khẩu thất bại');
    }
  }

  /// Đặt lại mật khẩu bằng mã và mật khẩu mới.
  Future<String> resetPassword(String token, String newPassword) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/users/reset-password'),
      headers: _buildHeaders(null),
      body: jsonEncode({'token': token, 'newPassword': newPassword}),
    );

    final dynamic body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return body['message'] as String;
    } else {
      throw HttpException((body['message'] as String?) ?? 'Đặt lại mật khẩu thất bại');
    }
  }

  // --- Existing Methods ---

  /// Đăng nhập bằng Google và lưu token backend vào Secure Storage.
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
        // Ném ra HttpException để test case có thể bắt đúng loại lỗi
        throw HttpException(
          'Đăng nhập thất bại: ${response.statusCode} - ${response.body}',
        );
      }
    } on HttpException {
      // Bắt lại HttpException để không bị bao bọc bởi Exception chung chung
      rethrow;
    } catch (e, s) {
      logger.e('Lỗi trong signInWithGoogle', error: e, stackTrace: s);
      // Ném ra Exception chung cho các lỗi khác
      throw Exception('Lỗi đăng nhập: $e');
    }
  }

  /// Đăng xuất và xóa token lưu trữ khi thành công.
  Future<void> logout() async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        await SecureStorageService.clearAll();
        return;
      }

      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/logout'),
        headers: _buildHeaders(token),
      );

      await SecureStorageService.clearAll();
      if (response.statusCode == 200) {
        logger.i('Đăng xuất thành công.');
      } else {
        logger.w('Đăng xuất thất bại trên server, nhưng đã xoá token ở client.');
      }
    } catch (e, s) {
      logger.e('Lỗi khi đăng xuất, vẫn xoá token ở client', error: e, stackTrace: s);
      await SecureStorageService.clearAll();
      if (e is HttpException) {
        rethrow;
      }
      throw Exception('Lỗi khi đăng xuất: $e');
    }
  }

  /// Lấy thông tin người dùng hiện tại (yêu cầu token hợp lệ).
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
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      logger.w(
        'Lỗi ${response.statusCode} - Forbidden/Unauthorized. Token có thể đã hết hạn hoặc không hợp lệ.',
      );
      throw HttpException('${response.statusCode}');
    } else {
      logger.e(
        'Không thể lấy thông tin user. Mã lỗi: ${response.statusCode}',
        error: response.body,
      );
      throw HttpException(
        'Không thể lấy thông tin user. Mã lỗi: ${response.statusCode}',
      );
    }
  }

  /// Thêm một manga vào danh sách theo dõi.
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
        throw HttpException(
          (error['message'] as String?) ??
              'Không thể thêm vào danh sách theo dõi',
        );
      }
      logger.i('Đã thêm manga $mangaId vào danh sách theo dõi.');
    } catch (e, s) {
      logger.e('Lỗi trong addToFollowing', error: e, stackTrace: s);
      if (e is HttpException) {
        rethrow;
      }
      throw Exception('Lỗi khi thêm manga: $e');
    }
  }

  /// Bỏ theo dõi một manga khỏi danh sách theo dõi.
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
          (error['message'] as String?) ?? 'Không thể bỏ theo dõi truyện',
        );
      }
      logger.i('Đã bỏ theo dõi manga $mangaId.');
    } catch (e, s) {
      logger.e('Lỗi trong removeFromFollowing', error: e, stackTrace: s);
      if (e is HttpException) {
        rethrow;
      }
      throw Exception('Lỗi khi bỏ theo dõi: $e');
    }
  }

  /// Kiểm tra xem người dùng có đang theo dõi `mangaId` hay không.
  Future<bool> checkIfUserIsFollowing(String mangaId) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        return false;
      }
      final http.Response response = await client.get(
        Uri.parse('$baseUrl/api/users/user/following/$mangaId'),
        headers: _buildHeaders(token),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            jsonDecode(response.body) as Map<String, dynamic>;
        return body['isFollowing'] as bool? ?? false;
      } else {
        logger.w(
          'Lỗi khi kiểm tra theo dõi',
          error: 'Status: ${response.statusCode}, Body: ${response.body}',
        );
        return false;
      }
    } catch (e, s) {
      logger.e(
        'Lỗi nghiêm trọng khi kiểm tra trạng thái theo dõi',
        error: e,
        stackTrace: s,
      );
      return false; // Trả về false nếu có lỗi để tránh crash app
    }
  }

  /// Cập nhật tiến độ đọc cho `mangaId` với `lastChapter` là chương cuối.
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
          (error['message'] as String?) ?? 'Không thể cập nhật tiến độ đọc',
        );
      }
      logger.i(
        'Đã cập nhật tiến độ đọc cho manga $mangaId, chapter $lastChapter',
      );
    } catch (e, s) {
      logger.e('Lỗi trong updateReadingProgress', error: e, stackTrace: s);
      if (e is HttpException) {
        rethrow;
      }
      throw Exception('Lỗi khi cập nhật tiến độ: $e');
    }
  }

  /// Xây dựng header kèm Bearer token cho các request yêu cầu xác thực.
  Map<String, String> _buildHeaders(String? token) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Lấy token hoặc ném lỗi nếu không tồn tại trong Secure Storage.
  Future<String> _getTokenOrThrow() async {
    final String? token = await SecureStorageService.getToken();
    if (token == null) {
      logger.w('Không tìm thấy token. Yêu cầu đăng nhập.');
      throw const HttpException('Không tìm thấy token');
    }
    return token;
  }

  /// Đóng `http.Client` để giải phóng tài nguyên.
  void dispose() {
    client.close();
  }
}
