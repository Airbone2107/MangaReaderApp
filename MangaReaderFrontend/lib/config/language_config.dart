/// Lớp cấu hình ngôn ngữ cho ứng dụng.
///
/// Chứa danh sách các ngôn ngữ ưu tiên để tìm kiếm và hiển thị chapter.
class LanguageConfig {
  /// Danh sách các mã ngôn ngữ ưu tiên (ISO 639-1).
  ///
  /// Trong tương lai, danh sách này có thể được đọc từ cài đặt của người dùng.
  static List<String> preferredLanguages = <String>['en', 'vi'];
}


