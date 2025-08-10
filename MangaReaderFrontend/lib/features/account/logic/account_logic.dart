import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manga_reader_app/core/services/language_service.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/data/models/manga/relationship.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../config/google_signin_config.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/mangadex_api_service.dart';
import '../../../data/services/user_api_service.dart';
import '../../../data/storage/secure_storage_service.dart';
import '../../../utils/logger.dart';
import '../../../utils/manga_helper.dart';
import '../../chapter_reader/view/chapter_reader_screen.dart';
import '../../detail_manga/view/manga_detail_screen.dart';

/// Lớp nghiệp vụ cho màn hình tài khoản.
///
/// Quản lý đăng nhập/đăng xuất, tải dữ liệu user, hiển thị danh sách theo dõi
/// và lịch sử đọc, cùng các tương tác liên quan.
class AccountScreenLogic {
  final MangaDexApiService _mangaDexService = MangaDexApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile'],
    serverClientId: GoogleSignInConfig.serverClientId,
  );
  final UserApiService _userService = UserApiService();
  final Map<String, Manga> _mangaCache = <String, Manga>{};

  User? user;
  bool isLoading = false;
  late BuildContext context;
  late VoidCallback refreshUI;

  /// Khởi tạo context và hàm cập nhật UI, sau đó tải dữ liệu người dùng.
  Future<void> init(BuildContext context, VoidCallback refreshUI) async {
    this.context = context;
    this.refreshUI = refreshUI;
    // Cài đặt ngôn ngữ Tiếng Việt cho timeago
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    await _loadUser();
  }

  /// Tải thông tin người dùng từ backend nếu có token hợp lệ.
  Future<void> _loadUser() async {
    isLoading = true;
    refreshUI();
    try {
      final bool hasToken = await SecureStorageService.hasValidToken();
      if (hasToken) {
        user = await _fetchUserData();
      } else {
        user = null;
      }
    } catch (e, s) {
      user = null;
      if (e is HttpException && (e.message == '403' || e.message == '401')) {
          logger.w('Token không hợp lệ, buộc đăng xuất.');
          await handleSignOut();
      }
      logger.e('Lỗi khi tải người dùng', error: e, stackTrace: s);
    } finally {
      isLoading = false;
      refreshUI();
    }
  }

  /// Xử lý đăng nhập Google và đồng bộ dữ liệu người dùng.
  Future<void> handleGoogleSignIn() async {
    isLoading = true;
    refreshUI();
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        isLoading = false;
        refreshUI();
        return;
      }
      await _userService.signInWithGoogle(account);
      user = await _fetchUserData();
    } catch (error, s) {
      logger.e('Lỗi đăng nhập Google', error: error, stackTrace: s);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi đăng nhập Google: $error')));
      }
      user = null;
    } finally {
      isLoading = false;
      refreshUI();
    }
  }

  /// Xử lý đăng xuất và dọn dẹp token.
  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _userService.logout();
      user = null;
      _mangaCache.clear();
      refreshUI();
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi đăng xuất: $error')));
      }
    }
  }

  /// Làm mới dữ liệu người dùng.
  Future<void> refreshUserData() async {
    await _loadUser();
  }

  /// Gọi service lấy dữ liệu người dùng.
  Future<User> _fetchUserData() async {
    return _userService.getUserData();
  }

  /// Bỏ theo dõi một manga và cập nhật giao diện.
  Future<void> handleUnfollow(String mangaId) async {
    try {
      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }
      isLoading = true;
      refreshUI();
      await _userService.removeFromFollowing(mangaId);
      user = await _fetchUserData();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã bỏ theo dõi truyện')));
      }
    } catch (e, s) {
      logger.e('Lỗi trong handleUnfollow', error: e, stackTrace: s);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi bỏ theo dõi: $e')));
      }
    } finally {
      isLoading = false;
      refreshUI();
    }
  }

  /// Lấy thông tin các manga dựa trên danh sách `mangaIds` và cache kết quả.
  Future<List<Manga>> _getMangaListInfo(List<String> mangaIds) async {
    try {
      final List<String> idsToFetch = mangaIds.where((id) => !_mangaCache.containsKey(id)).toList();
      if (idsToFetch.isNotEmpty) {
        final List<Manga> mangas = await _mangaDexService.fetchMangaByIds(idsToFetch);
        for (final Manga manga in mangas) {
          _mangaCache[manga.id] = manga;
        }
      }
      return mangaIds.map((id) => _mangaCache[id]).whereType<Manga>().toList();
    } catch (e, s) {
      logger.w(
        'Lỗi khi lấy thông tin danh sách manga',
        error: e,
        stackTrace: s,
      );
      return [];
    }
  }

  /// Widget xây dựng nội dung cho tab "Truyện theo dõi"
  Widget buildFollowingTab() {
    final followingIds = user?.following ?? [];
    if (followingIds.isEmpty) {
      return const Center(child: Text('Bạn chưa theo dõi truyện nào.'));
    }
    return FutureBuilder<List<Manga>>(
      future: _getMangaListInfo(followingIds),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải truyện: ${snapshot.error}'));
        }
        final mangas = snapshot.data ?? [];
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: mangas.length,
          itemBuilder: (context, index) {
            return _buildMangaListItem(mangas[index], isFollowing: true);
          },
        );
      },
    );
  }

  /// Widget xây dựng nội dung cho tab "Lịch sử đọc"
  Widget buildHistoryTab() {
    final readingHistory = user?.readingProgress ?? [];
    if (readingHistory.isEmpty) {
      return const Center(child: Text('Lịch sử đọc của bạn trống.'));
    }
    final historyIds = readingHistory.map((p) => p.mangaId).toList();
    
    return FutureBuilder<List<Manga>>(
      future: _getMangaListInfo(historyIds),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải lịch sử: ${snapshot.error}'));
        }
        final mangasMap = {for (var m in snapshot.data ?? []) m.id: m};
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: readingHistory.length,
          itemBuilder: (context, index) {
            final progress = readingHistory[index];
            final manga = mangasMap[progress.mangaId];
            if (manga == null) return const SizedBox.shrink();
            return _buildMangaListItem(
              manga,
              isFollowing: false,
              readingProgress: progress,
            );
          },
        );
      },
    );
  }

  /// Xây dựng một item hiển thị manga.
  Widget _buildMangaListItem(
    Manga manga, {
    required bool isFollowing,
    ReadingProgress? readingProgress,
  }) {
    final String title = manga.getDisplayTitle();
    final itemContent = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    MangaDetailScreen(mangaId: manga.id),
              ),
            ),
            child: SizedBox(
              width: 80,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: _buildCoverImage(manga),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                isFollowing
                    ? _buildLatestChaptersInfo(manga.id)
                    : _buildLastReadInfo(manga, readingProgress),
              ],
            ),
          ),
        ],
      ),
    );

    if (!isFollowing) return itemContent;

    return Slidable(
      key: ValueKey('following-${manga.id}'),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.32,
        children: [
          SlidableAction(
            onPressed: (_) => handleUnfollow(manga.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Bỏ theo dõi',
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
        ],
      ),
      child: itemContent,
    );
  }

  Widget _buildLatestChaptersInfo(String mangaId) {
    return FutureBuilder<List<dynamic>>(
      future: _mangaDexService.fetchChapters(
        mangaId,
        LanguageService.instance.preferredLanguages,
        limit: 3,
      ),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 50,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Không thể tải chapter mới.');
        }

        final chapters = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: chapters.map((chapterData) {
            final attributes = chapterData['attributes'] as Map<String, dynamic>;
            final String chapterNumber = attributes['chapter'] as String? ?? 'N/A';
            final String chapterTitle = attributes['title'] as String? ?? '';
            final String langCode = attributes['translatedLanguage'] as String? ?? '??';
            final String? flagAsset = LanguageService.instance.getFlagAssetByLanguageCode(langCode);

            final String displayTitle = chapterTitle.isEmpty || chapterTitle == chapterNumber
                ? 'Chương $chapterNumber'
                : 'Chương $chapterNumber: $chapterTitle';

            String? timeText;
            try {
              final String? ts = (attributes['publishAt'] ?? attributes['createdAt'] ?? attributes['readableAt']) as String?;
              if (ts != null) {
                final dt = DateTime.tryParse(ts);
                if (dt != null) {
                  timeText = timeago.format(dt.toLocal(), locale: 'vi');
                }
              }
            } catch (_) {
              timeText = null;
            }

            return InkWell(
              onTap: () async {
                final fullChapterList = await _mangaDexService.fetchChapters(
                    mangaId, LanguageService.instance.preferredLanguages);
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChapterReaderScreen(
                        chapter: Chapter(
                          mangaId: mangaId,
                          chapterId: chapterData['id'] as String,
                          chapterName: displayTitle,
                          chapterList: fullChapterList,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    if (flagAsset != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: SvgPicture.asset(flagAsset, width: 20, height: 15, fit: BoxFit.cover),
                      )
                    else
                      const SizedBox(width: 26),
                    Expanded(
                      child: Text(
                        displayTitle,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (timeText != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        timeText!,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
  
  Widget _buildLastReadInfo(Manga manga, ReadingProgress? progress) {
    if (progress == null) {
      return const Text('Chưa đọc chapter nào', style: TextStyle(fontSize: 13));
    }
    
    final ChapterInfo chapterInfo = progress.lastReadChapter;
    final chapterNumber = chapterInfo.chapter ?? 'N/A';
    final chapterTitle = chapterInfo.title ?? '';
    final chapterLine = chapterTitle.isEmpty || chapterTitle == chapterNumber
        ? 'Chương $chapterNumber'
        : 'Chương $chapterNumber: $chapterTitle';
    final timeAgo = timeago.format(progress.lastReadAt, locale: 'vi');

    return InkWell(
      onTap: () async {
        final fullChapterList = await _mangaDexService.fetchChapters(
            manga.id, LanguageService.instance.preferredLanguages);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ChapterReaderScreen(
                chapter: Chapter(
                  mangaId: manga.id,
                  chapterId: chapterInfo.id,
                  chapterName: chapterLine,
                  chapterList: fullChapterList,
                ),
              ),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Đang đọc'),
          const SizedBox(height: 2),
          Text(
            chapterLine,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          Text(
            timeAgo,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          )
        ],
      ),
    );
  }

  /// Dựng widget ảnh bìa cho manga.
  Widget _buildCoverImage(Manga manga) {
    String? coverFileName;
    try {
      final Relationship coverArtRelationship = manga.relationships.firstWhere(
        (rel) => rel.type == 'cover_art',
      );
      if (coverArtRelationship.attributes != null) {
        coverFileName = coverArtRelationship.attributes!['fileName'] as String?;
      }
    } catch (e) {
      coverFileName = null;
    }

    if (coverFileName != null) {
      final String imageUrl =
          'https://uploads.mangadex.org/covers/${manga.id}/$coverFileName.512.jpg';
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) =>
                const Icon(Icons.broken_image),
      );
    }
    return const Icon(Icons.broken_image);
  }

  /// Giải phóng tài nguyên nếu cần.
  void dispose() {
    _userService.dispose();
  }
}


