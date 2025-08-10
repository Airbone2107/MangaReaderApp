import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manga_reader_app/core/services/language_service.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/data/models/manga/relationship.dart';
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
      final List<Manga> mangas = await _mangaDexService.fetchMangaByIds(
        mangaIds,
      );
      for (final Manga manga in mangas) {
        _mangaCache[manga.id] = manga;
      }
      return mangas;
    } catch (e, s) {
      logger.w(
        'Lỗi khi lấy thông tin danh sách manga',
        error: e,
        stackTrace: s,
      );
      return <Manga>[];
    }
  }

  /// Xây dựng danh sách manga theo tiêu đề và id.
  Widget buildMangaListView(
    String title,
    List<String> mangaIds, {
    bool isFollowing = false,
  }) {
    if (mangaIds.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Không có truyện nào.'),
            ],
          ),
        ),
      );
    }

    return FutureBuilder<List<Manga>>(
      future: _getMangaListInfo(mangaIds),
      builder: (BuildContext context, AsyncSnapshot<List<Manga>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _mangaCache.keys.where((k) => mangaIds.contains(k)).isEmpty) {
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: const Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: Text('Lỗi: ${snapshot.error}'),
            ),
          );
        }
        
        final List<Manga> mangasFromIds = mangaIds
            .map((id) => _mangaCache[id])
            .whereType<Manga>()
            .toList();
        return Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mangasFromIds.length,
                itemBuilder: (BuildContext context, int index) {
                  final Manga manga = mangasFromIds[index];
                  ChapterInfo? lastReadChapterInfo;
                  if (!isFollowing && user != null) {
                    try {
                      final ReadingProgress progress = user!.readingProgress.firstWhere(
                          (p) => p.mangaId == manga.id);
                      lastReadChapterInfo = progress.lastReadChapter;
                    } catch (e) {
                      lastReadChapterInfo = null;
                    }
                  }
                  return _buildMangaListItem(
                    manga,
                    isFollowing: isFollowing,
                    lastReadChapterInfo: lastReadChapterInfo,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Xây dựng một item hiển thị manga.
  Widget _buildMangaListItem(
    Manga manga, {
    required bool isFollowing,
    ChapterInfo? lastReadChapterInfo,
  }) {
    final String title = manga.getDisplayTitle();
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                  ? _buildLatestChapterInfo(manga.id)
                  : _buildLastReadChapterInfo(manga.id, lastReadChapterInfo),
              ],
            ),
          ),
          if (isFollowing)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => handleUnfollow(manga.id),
            ),
        ],
      ),
    );
  }
 
  Widget _buildLatestChapterInfo(String mangaId) {
    return FutureBuilder<List<dynamic>>(
      future: _mangaDexService.fetchChapters(
        mangaId,
        LanguageService.instance.preferredLanguages,
        maxChapters: 1,
      ),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 50,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || snapshot.data!.isEmpty) {
          return const Text('Không thể tải chapter');
        }
        final dynamic chapterData = snapshot.data!.first;
        final attributes = chapterData['attributes'] as Map<String, dynamic>;
        final String chapterNumber = attributes['chapter'] as String? ?? 'N/A';
        final String chapterTitle = attributes['title'] as String? ?? '';
        final String displayTitle = chapterTitle.isEmpty
            ? 'Chương $chapterNumber'
            : 'Chương $chapterNumber: $chapterTitle';
            
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            displayTitle,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () async {
            // Cần tải lại toàn bộ danh sách chapter khi nhấn vào
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
        );
      },
    );
  }

  Widget _buildLastReadChapterInfo(String mangaId, ChapterInfo? chapterInfo) {
    if (chapterInfo == null) {
      return const Text('Chưa đọc chapter nào', style: TextStyle(fontSize: 13));
    }

    final chapterNumber = chapterInfo.chapter ?? 'N/A';
    final chapterTitle = chapterInfo.title ?? '';
    final displayTitle = chapterTitle.isEmpty || chapterTitle == chapterNumber
        ? 'Đang đọc: Chương $chapterNumber'
        : 'Đang đọc: Chương $chapterNumber: $chapterTitle';
        
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        displayTitle,
        style: const TextStyle(fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
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
                  chapterId: chapterInfo.id,
                  chapterName: displayTitle.replaceFirst('Đang đọc: ', ''),
                  chapterList: fullChapterList,
                ),
              ),
            ),
          );
        }
      },
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


