// lib/app.dart
import 'package:flutter/material.dart';
import 'features/main_navigation/view/main_navigation_screen.dart';

/// Ứng dụng chính của Manga Reader.
///
/// Khởi tạo `MaterialApp` với route gốc trỏ tới `MainNavigationScreen`.
class MangaReaderApp extends StatelessWidget {
  const MangaReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const MainNavigationScreen(),
      },
    );
  }
}
