import '../../data/models/language_info.dart';

/// Service để quản lý mã ngôn ngữ và các tùy chọn bản địa hóa.
///
/// Sử dụng Singleton pattern để đảm bảo chỉ có một instance trong toàn bộ ứng dụng.
class LanguageService {
  // Singleton instance
  static final LanguageService _instance = LanguageService._internal();

  /// Lấy instance duy nhất của LanguageService.
  static LanguageService get instance => _instance;

  LanguageService._internal();

  /// Danh sách các ngôn ngữ được MangaDex hỗ trợ.
  final List<LanguageInfo> _supportedLanguages = const [
    LanguageInfo(code: 'en', name: 'Tiếng Anh'),
    LanguageInfo(code: 'vi', name: 'Tiếng Việt'),
    LanguageInfo(code: 'zh', name: 'Tiếng Trung (Giản thể)'),
    LanguageInfo(code: 'zh-hk', name: 'Tiếng Trung (Phồn thể)'),
    LanguageInfo(code: 'pt-br', name: 'Tiếng Bồ Đào Nha (Brazil)'),
    LanguageInfo(code: 'es', name: 'Tiếng Tây Ban Nha (Castilian)'),
    LanguageInfo(code: 'es-la', name: 'Tiếng Tây Ban Nha (Mỹ Latin)'),
    LanguageInfo(code: 'ja', name: 'Tiếng Nhật'),
    LanguageInfo(code: 'ja-ro', name: 'Tiếng Nhật (Latinh)'),
    LanguageInfo(code: 'ko', name: 'Tiếng Hàn'),
    LanguageInfo(code: 'ko-ro', name: 'Tiếng Hàn (Latinh)'),
    LanguageInfo(code: 'zh-ro', name: 'Tiếng Trung (Latinh)'),
    LanguageInfo(code: 'ar', name: 'Tiếng Ả Rập'),
    LanguageInfo(code: 'de', name: 'Tiếng Đức'),
    LanguageInfo(code: 'fr', name: 'Tiếng Pháp'),
    LanguageInfo(code: 'id', name: 'Tiếng Indonesia'),
    LanguageInfo(code: 'ru', name: 'Tiếng Nga'),
    LanguageInfo(code: 'th', name: 'Tiếng Thái'),
    // Thêm các ngôn ngữ khác nếu cần
  ];

  /// Danh sách ngôn ngữ ưu tiên của người dùng.
  ///
  /// Trong tương lai, danh sách này có thể được tải từ cài đặt của người dùng.
  List<String> _preferredLanguages = ['en', 'vi'];

  /// Cung cấp danh sách ngôn ngữ ưu tiên (chỉ đọc).
  List<String> get preferredLanguages => List.unmodifiable(_preferredLanguages);

  /// Cung cấp danh sách tất cả ngôn ngữ được hỗ trợ.
  List<LanguageInfo> get supportedLanguages => _supportedLanguages;

  /// Cập nhật danh sách ngôn ngữ ưu tiên.
  void updatePreferredLanguages(List<String> newLanguages) {
    // Thêm logic kiểm tra xem newLanguages có hợp lệ không nếu cần.
    _preferredLanguages = newLanguages;
    // Có thể lưu vào SharedPreferences hoặc SecureStorage ở đây.
  }

  /// Lấy tên ngôn ngữ từ mã code.
  String getLanguageNameByCode(String code) {
    try {
      return _supportedLanguages
          .firstWhere(
            (lang) => lang.code == code,
            orElse: () => const LanguageInfo(code: '??', name: 'Không rõ'),
          )
          .name;
    } catch (e) {
      return 'Không rõ';
    }
  }

  /// Trả về đường dẫn asset của cờ tương ứng với mã ngôn ngữ.
  ///
  /// Sử dụng bộ cờ trong `assets/flags/{variant}/...`. Mặc định dùng tỉ lệ 4x3.
  /// Nếu không tìm được ánh xạ phù hợp, trả về `null` để UI tự hiển thị fallback.
  String? getFlagAssetByLanguageCode(String code, {String variant = '4x3'}) {
    final String normalized = code.toLowerCase();
    String? countryCode;

    switch (normalized) {
      case 'vi':
        countryCode = 'vn';
        break;
      case 'en':
        // Dùng cờ UK mặc định cho English. Có thể đổi sang 'us' tùy prefer.
        countryCode = 'gb';
        break;
      case 'en-us':
        countryCode = 'us';
        break;
      case 'pt-br':
        countryCode = 'br';
        break;
      case 'es':
        countryCode = 'es';
        break;
      case 'es-la':
        // Latin American Spanish: chọn Mexico làm đại diện phổ biến
        countryCode = 'mx';
        break;
      case 'zh':
        countryCode = 'cn';
        break;
      case 'zh-hk':
        countryCode = 'hk';
        break;
      case 'ja':
      case 'ja-ro':
        countryCode = 'jp';
        break;
      case 'ko':
      case 'ko-ro':
        countryCode = 'kr';
        break;
      case 'zh-ro':
        countryCode = 'cn';
        break;
      case 'ar':
        // Bộ cờ có lá 'arab' đại diện khối Arab
        countryCode = 'arab';
        break;
      case 'de':
        countryCode = 'de';
        break;
      case 'fr':
        countryCode = 'fr';
        break;
      case 'id':
        countryCode = 'id';
        break;
      case 'ru':
        countryCode = 'ru';
        break;
      case 'th':
        countryCode = 'th';
        break;
      default:
        // Nếu là mã 2 ký tự, thử dùng luôn (trùng ISO country của nhiều ngôn ngữ)
        if (normalized.length == 2) {
          countryCode = normalized;
        } else {
          countryCode = null;
        }
    }

    if (countryCode == null) return null;
    return 'assets/flags/$variant/$countryCode.svg';
  }
}


