import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  // Lưu token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Lấy token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Xóa token
  static Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Kiểm tra xem có token hợp lệ không
  static Future<bool> hasValidToken() async {
    final String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Xóa tất cả dữ liệu
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
