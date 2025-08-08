import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service tiện ích để thao tác với `FlutterSecureStorage`.
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  /// Lưu token xác thực vào Secure Storage.
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Lấy token xác thực từ Secure Storage.
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Xóa token xác thực khỏi Secure Storage.
  static Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Kiểm tra token có tồn tại và không rỗng.
  static Future<bool> hasValidToken() async {
    final String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Xóa toàn bộ dữ liệu lưu trong Secure Storage.
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
