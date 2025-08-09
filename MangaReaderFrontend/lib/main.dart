// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'app.dart';

/// Điểm vào của ứng dụng.
///
/// Đảm bảo binding đã được khởi tạo trước khi chạy `MangaReaderApp`.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MangaReaderApp()));
}
