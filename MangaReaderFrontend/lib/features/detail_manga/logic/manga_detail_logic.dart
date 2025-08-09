import 'package:flutter/material.dart';
import 'package:manga_reader_app/config/language_config.dart';
import 'package:manga_reader_app/data/models/manga/manga_statistics.dart';
import '../../../data/models/manga/manga.dart';
import '../../../data/services/mangadex_api_service.dart';
import '../../../data/services/user_api_service.dart';
import '../../../data/storage/secure_storage_service.dart';
import '../../../utils/logger.dart';

/// Nghiệp vụ cho màn chi tiết Manga: tải chi tiết, chapters và theo dõi.
class MangaDetailLogic {
  final String mangaId;
  final VoidCallback refreshUI;

  final MangaDexApiService _mangaDexService = MangaDexApiService();
  final UserApiService _userApiService = UserApiService();

  late Future<(Manga, MangaStatisticsData)> pageData;
  /// Danh sách chapter dạng raw theo ngôn ngữ (giữ nguyên vì model chưa hoàn thiện).
  late Future<List<dynamic>> chapters;
  bool isFollowing = false;

  MangaDetailLogic({required this.mangaId, required this.refreshUI}) {
    _init();
  }

  /// Khởi tạo dữ liệu ban đầu.
  void _init() {
    pageData = _fetchPageData();
    chapters = _mangaDexService.fetchChapters(
      mangaId,
      LanguageConfig.preferredLanguages,
    );
    checkFollowingStatus();
  }

  /// Tải đồng thời chi tiết manga và thống kê.
  Future<(Manga, MangaStatisticsData)> _fetchPageData() async {
    try {
      final results = await Future.wait([
        _mangaDexService.fetchMangaDetails(mangaId),
        _mangaDexService.fetchMangaStatistics(mangaId),
      ]);
      return (results[0] as Manga, results[1] as MangaStatisticsData);
    } catch (e, s) {
      logger.e('Lỗi khi tải dữ liệu trang chi tiết', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Kiểm tra trạng thái theo dõi của người dùng với manga hiện tại.
  Future<void> checkFollowingStatus() async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        isFollowing = false;
        refreshUI();
        return;
      }
      final bool following = await _userApiService.checkIfUserIsFollowing(
        mangaId,
      );
      isFollowing = following;
      refreshUI();
    } catch (e, s) {
      logger.w('Lỗi khi kiểm tra theo dõi', error: e, stackTrace: s);
      isFollowing = false;
      refreshUI();
    }
  }

  /// Thay đổi trạng thái theo dõi và thông báo tới người dùng.
  Future<void> toggleFollowStatus(BuildContext context) async {
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

    try {
      if (isFollowing) {
        await _userApiService.removeFromFollowing(mangaId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã bỏ theo dõi truyện.')),
          );
        }
      } else {
        await _userApiService.addToFollowing(mangaId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã thêm truyện vào danh sách theo dõi.'),
            ),
          );
        }
      }
      await checkFollowingStatus();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }
}
