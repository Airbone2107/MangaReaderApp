import 'package:flutter/material.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/services/mangadex_api_service.dart';
import '../../../data/services/user_api_service.dart';
import '../../../data/storage/secure_storage_service.dart';
import '../../../utils/logger.dart';
import '../view/chapter_reader_screen.dart';

class ChapterReaderLogic {
  final Function(VoidCallback) setState;
  final UserApiService userService;
  final ScrollController scrollController;
  final MangaDexApiService mangaDexService = MangaDexApiService();

  bool areBarsVisible = true;
  double lastOffset = 0.0;
  double scrollThreshold = 50.0;

  ChapterReaderLogic({
    required this.setState,
    required this.userService,
    required this.scrollController,
  }) {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final double currentOffset = scrollController.offset;
    final double delta = currentOffset - lastOffset;

    if (delta.abs() > scrollThreshold) {
      if (delta > 0 && areBarsVisible) {
        setState(() => areBarsVisible = false);
      } else if (delta < 0 && !areBarsVisible) {
        setState(() => areBarsVisible = true);
      }
      lastOffset = currentOffset;
    }
  }

  int getCurrentIndex(Chapter chapter) {
    return chapter.chapterList.indexWhere(
      (dynamic ch) => ch['id'] == chapter.chapterId,
    );
  }

  String getChapterDisplayName(Map<String, dynamic> chapter) {
    final String chapterNumber =
        chapter['attributes']['chapter'] as String? ?? 'N/A';
    final String chapterTitle = chapter['attributes']['title'] as String? ?? '';
    return chapterTitle.isEmpty || chapterTitle == chapterNumber
        ? 'Chương $chapterNumber'
        : 'Chương $chapterNumber: $chapterTitle';
  }

  Future<List<String>> fetchChapterPages(String chapterId) {
    return mangaDexService.fetchChapterPages(chapterId);
  }

  void goToNextChapter(
    BuildContext context,
    Chapter chapter,
    int currentIndex,
  ) {
    if (currentIndex > 0) {
      final dynamic nextChapterData = chapter.chapterList[currentIndex - 1];
      _navigateToChapter(
        context,
        chapter,
        nextChapterData as Map<String, dynamic>,
      );
    }
  }

  void goToPreviousChapter(
    BuildContext context,
    Chapter chapter,
    int currentIndex,
  ) {
    if (currentIndex < chapter.chapterList.length - 1) {
      final dynamic prevChapterData = chapter.chapterList[currentIndex + 1];
      _navigateToChapter(
        context,
        chapter,
        prevChapterData as Map<String, dynamic>,
      );
    }
  }

  void _navigateToChapter(
    BuildContext context,
    Chapter currentChapter,
    Map<String, dynamic> newChapterData,
  ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChapterReaderScreen(
          chapter: Chapter(
            mangaId: currentChapter.mangaId,
            chapterId: newChapterData['id'] as String,
            chapterName: getChapterDisplayName(newChapterData),
            chapterList: currentChapter.chapterList,
          ),
        ),
      ),
    );
  }

  Future<void> followManga(BuildContext context, String mangaId) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng đăng nhập để theo dõi truyện.'),
            ),
          );
        }
        return;
      }
      await userService.addToFollowing(mangaId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã thêm truyện vào danh sách theo dõi.'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi thêm truyện: $e')));
      }
    }
  }

  Future<void> removeFromFollowing(BuildContext context, String mangaId) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng đăng nhập để bỏ theo dõi truyện.'),
            ),
          );
        }
        return;
      }
      await userService.removeFromFollowing(mangaId);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã bỏ theo dõi truyện.')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi bỏ theo dõi truyện: $e')),
        );
      }
    }
  }

  Future<bool> isFollowingManga(String mangaId) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        return false;
      }
      return await userService.checkIfUserIsFollowing(mangaId);
    } catch (e, s) {
      logger.w('Lỗi khi kiểm tra theo dõi', error: e, stackTrace: s);
      return false;
    }
  }

  Future<void> updateProgress(String mangaId, String chapterId) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token != null) {
        await userService.updateReadingProgress(mangaId, chapterId);
      }
    } catch (e, s) {
      logger.w('Lỗi khi cập nhật tiến độ đọc', error: e, stackTrace: s);
    }
  }

  void dispose() {
    scrollController.removeListener(_onScroll);
  }
}
