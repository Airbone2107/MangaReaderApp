import 'package:flutter/material.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/mangadex_api_service.dart';
import '../../../data/services/user_api_service.dart';
import '../../../data/storage/secure_storage_service.dart';
import '../../../utils/logger.dart';
import '../view/chapter_reader_screen.dart';

/// Nghiệp vụ cho màn hình đọc chapter.
///
/// Xử lý ẩn/hiện thanh điều hướng khi cuộn, điều hướng giữa các chapter,
/// theo dõi trạng thái theo dõi và cập nhật tiến độ đọc.
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

  /// Lắng nghe sự kiện cuộn để quyết định ẩn/hiện thanh điều hướng.
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

  /// Vị trí index của chapter hiện tại trong `chapter.chapterList`.
  int getCurrentIndex(Chapter chapter) {
    return chapter.chapterList.indexWhere(
      (dynamic ch) => ch['id'] == chapter.chapterId,
    );
  }

  /// Lấy thông tin chi tiết của một chapter từ danh sách chapter.
  Map<String, dynamic> getChapterData(Chapter chapter, String chapterId) {
    return chapter.chapterList.firstWhere(
      (ch) => ch['id'] == chapterId,
      orElse: () => <String, dynamic>{},
    );
  }

  /// Tạo tên hiển thị cho chapter dựa trên số và tiêu đề.
  String getChapterDisplayName(Map<String, dynamic> chapterData) {
    if (chapterData.isEmpty || chapterData['attributes'] == null) {
      return 'Chapter không xác định';
    }
    final attributes = chapterData['attributes'] as Map<String, dynamic>;
    final String chapterNumber = attributes['chapter'] as String? ?? 'N/A';
    final String chapterTitle = attributes['title'] as String? ?? '';
    return chapterTitle.isEmpty || chapterTitle == chapterNumber
        ? 'Chương $chapterNumber'
        : 'Chương $chapterNumber: $chapterTitle';
  }

  /// Tải danh sách URL trang ảnh của chapter.
  Future<List<String>> fetchChapterPages(String chapterId) {
    return mangaDexService.fetchChapterPages(chapterId);
  }

  /// Điều hướng tới chapter kế tiếp (nếu có).
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

  /// Điều hướng tới chapter trước đó (nếu có).
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

  /// Thay thế màn hình hiện tại bằng chapter mới.
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

  /// Thêm manga vào danh sách theo dõi nếu đã đăng nhập.
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

  /// Bỏ theo dõi manga nếu đã đăng nhập.
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

  /// Kiểm tra trạng thái theo dõi.
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

  /// Cập nhật tiến độ đọc lên backend nếu có token.
  Future<void> updateProgress(Chapter chapter) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token != null) {
        final chapterData = getChapterData(chapter, chapter.chapterId);
        if (chapterData.isNotEmpty) {
          final attributes = chapterData['attributes'] as Map<String, dynamic>;
          final chapterInfo = ChapterInfo(
            id: chapter.chapterId,
            chapter: attributes['chapter'] as String?,
            title: attributes['title'] as String?,
            translatedLanguage: attributes['translatedLanguage'] as String,
          );
          await userService.updateReadingProgress(chapter.mangaId, chapterInfo);
        }
      }
    } catch (e, s) {
      logger.w('Lỗi khi cập nhật tiến độ đọc', error: e, stackTrace: s);
    }
  }

  /// Hủy lắng nghe cuộn để tránh rò rỉ tài nguyên.
  void dispose() {
    scrollController.removeListener(_onScroll);
  }
}


