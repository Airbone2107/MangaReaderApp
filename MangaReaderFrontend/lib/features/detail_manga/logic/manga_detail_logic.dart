import 'package:flutter/material.dart';
import '../../../data/models/manga/manga.dart';
import '../../../data/services/mangadex_api_service.dart';
import '../../../data/services/user_api_service.dart';
import '../../../data/storage/secure_storage_service.dart';
import '../../../utils/logger.dart';

class MangaDetailLogic {
  final String mangaId;
  final VoidCallback refreshUI;

  final MangaDexApiService _mangaDexService = MangaDexApiService();
  final UserApiService _userApiService = UserApiService();

  late Future<Manga> mangaDetails;
  late Future<List<dynamic>>
  chapters; // Giữ nguyên vì Chapter model chưa hoàn thiện
  late Future<String> coverUrl;
  bool isFollowing = false;

  MangaDetailLogic({required this.mangaId, required this.refreshUI}) {
    _init();
  }

  void _init() {
    final List<String> defaultLanguages = <String>['en', 'vi'];
    mangaDetails = _mangaDexService.fetchMangaDetails(mangaId);
    chapters = _mangaDexService.fetchChapters(
      mangaId,
      defaultLanguages.join(','),
    );
    coverUrl = _mangaDexService.fetchCoverUrl(mangaId);
    checkFollowingStatus();
  }

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
