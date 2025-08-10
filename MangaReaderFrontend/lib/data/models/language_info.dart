/// Đại diện cho thông tin của một ngôn ngữ.
class LanguageInfo {
  /// Mã ngôn ngữ theo chuẩn ISO 639-1 (ví dụ: 'en', 'vi') hoặc mở rộng (ví dụ: 'pt-br').
  final String code;

  /// Tên đầy đủ của ngôn ngữ bằng tiếng Anh.
  final String name;

  const LanguageInfo({required this.code, required this.name});
}


