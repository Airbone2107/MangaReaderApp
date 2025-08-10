import 'package:flutter/material.dart';
import '../../../data/models/manga/manga_statistics.dart';
import '../widgets/chapters_tab.dart';
import '../widgets/manga_info_tab.dart';
import '../widgets/related_manga_tab.dart';
import '../../../data/models/manga/manga.dart';
import '../logic/manga_detail_logic.dart';

class MangaDetailScreen extends StatefulWidget {
  final String mangaId;
  const MangaDetailScreen({super.key, required this.mangaId});

  @override
  State<MangaDetailScreen> createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen> {
  late MangaDetailLogic _logic;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _logic = MangaDetailLogic(
      mangaId: widget.mangaId,
      refreshUI: () {
        if (mounted) {
          setState(() {});
        }
      },
    );

    _pageController.addListener(() {
      final newPage = _pageController.page?.round();
      if (newPage != null && newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang ${_currentPage + 1} / 3'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _logic.isFollowing ? Icons.bookmark : Icons.bookmark_outline,
              color: _logic.isFollowing ? Colors.green : null,
            ),
            onPressed: () => _logic.toggleFollowStatus(context),
          ),
        ],
      ),
      body: FutureBuilder<(Manga, MangaStatisticsData)>(
        future: _logic.pageData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi tải dữ liệu: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu'));
          } else {
            final (manga, stats) = snapshot.data!;
            return PageView(
              controller: _pageController,
              children: [
                ChaptersTab(manga: manga, chaptersFuture: _logic.chapters),
                MangaInfoTab(manga: manga, stats: stats),
                RelatedMangaTab(manga: manga),
              ],
            );
          }
        },
      ),
    );
  }
}