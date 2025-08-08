import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Logger toàn cục dùng trong toàn bộ ứng dụng.
///
/// - Ở chế độ debug: mức `trace` trở lên.
/// - Ở chế độ release: mức `warning` trở lên.
final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.none,
  ),
  level: kDebugMode ? Level.trace : Level.warning,
);
