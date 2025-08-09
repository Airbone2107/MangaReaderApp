import 'package:flutter/material.dart';
import 'package:manga_reader_app/features/home/widgets/discover_section.dart';

/// Màn hình trang chủ: chỉ giữ lại phần Khám Phá (DiscoverSection).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trả về trực tiếp DiscoverSection để tránh lồng Scaffold không cần thiết
    return const DiscoverSection();
  }
}
