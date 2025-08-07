import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// Biến logger toàn cục để dễ dàng truy cập từ mọi nơi trong ứng dụng.
final Logger logger = Logger(
  // Tùy chỉnh cách logger in ra console.
  printer: PrettyPrinter(
    methodCount: 1, // Chỉ hiển thị 1 dòng call stack.
    errorMethodCount: 8, // Hiển thị 8 dòng call stack cho lỗi.
    lineLength: 120, // Độ rộng của log.
    colors: true, // Bật màu sắc cho các cấp độ log khác nhau.
    printEmojis: true, // Hiển thị emoji cho mỗi cấp độ log.
    dateTimeFormat: DateTimeFormat.none, // Không cần hiển thị thời gian.
  ),
  // Cài đặt cấp độ log.
  // Trong chế độ debug, hiển thị tất cả log từ cấp độ 'trace' trở lên.
  // Trong chế độ release, chỉ hiển thị log từ cấp độ 'warning' trở lên.
  level: kDebugMode ? Level.trace : Level.warning,
);
