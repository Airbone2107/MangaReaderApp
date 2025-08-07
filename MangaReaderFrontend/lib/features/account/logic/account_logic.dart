import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import '../../../config/google_signin_config.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/mangadex_api_service.dart';
import '../../../data/services/user_api_service.dart';
import '../../../data/storage/secure_storage_service.dart';
import '../../../utils/logger.dart';
import '../../chapter_reader/view/chapter_reader_screen.dart';
import '../../detail_manga/view/manga_detail_screen.dart';

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

  Future<void> init(BuildContext context, VoidCallback refreshUI) async {
    this.context = context;
    this.refreshUI = refreshUI;
    await _loadUser();
  }

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
      if (e is HttpException && e.message == '403') {
        logger.w('Token không hợp lệ, buộc đăng xuất.');
        await handleSignOut(); // Token is invalid, force sign out
      }
      logger.e('Lỗi khi tải người dùng', error: e, stackTrace: s);
    } finally {
      isLoading = false;
      refreshUI();
    }
  }

  Future<void> handleSignIn() async {
    isLoading = true;
    refreshUI();
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('Đăng nhập bị hủy');
      }
      await _userService.signInWithGoogle(account);
      user = await _fetchUserData();
    } catch (error, s) {
      logger.e('Lỗi đăng nhập', error: error, stackTrace: s);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi đăng nhập: $error')));
      }
      user = null;
    } finally {
      isLoading = false;
      refreshUI();
    }
  }

  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await SecureStorageService.removeToken();
      user = null;
      refreshUI();
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi đăng xuất: $error')));
      }
    }
  }

  Future<void> refreshUserData() async {
    await _loadUser();
  }

  Future<User> _fetchUserData() async {
    return _userService.getUserData();
  }

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

  Widget buildMangaListView(
    String title,
    List<String> mangaIds, {
    bool isFollowing = false,
  }) {
    return FutureBuilder<List<Manga>>(
      future: _getMangaListInfo(mangaIds),
      builder: (BuildContext context, AsyncSnapshot<List<Manga>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
        final List<Manga> mangas = snapshot.data ?? <Manga>[];
        for (final Manga manga in mangas) {
          _mangaCache[manga.id] = manga;
        }
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
                itemCount: mangaIds.length,
                itemBuilder: (BuildContext context, int index) {
                  final String mangaId = mangaIds[index];
                  final Manga? manga = _mangaCache[mangaId];
                  if (manga == null) {
                    return const SizedBox.shrink();
                  }
                  String? lastReadChapter;
                  if (!isFollowing && user != null) {
                    final ReadingProgress progress = user!.readingProgress
                        .firstWhere(
                          (ReadingProgress p) => p.mangaId == mangaId,
                          orElse: () => ReadingProgress(
                            mangaId: mangaId,
                            lastChapter: '',
                            lastReadAt: DateTime.now(),
                          ),
                        );
                    lastReadChapter = progress.lastChapter;
                  }
                  return _buildMangaListItem(
                    manga,
                    isFollowing: isFollowing,
                    mangaId: mangaId,
                    lastReadChapter: lastReadChapter,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMangaListItem(
    Manga manga, {
    bool isFollowing = false,
    required String mangaId,
    String? lastReadChapter,
  }) {
    final String title = manga.attributes.title['en'] ?? 'Không có tiêu đề';
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
                    MangaDetailScreen(mangaId: mangaId),
              ),
            ),
            child: SizedBox(
              width: 80,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: FutureBuilder<String>(
                  future: _mangaDexService.fetchCoverUrl(mangaId),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                ) => const Icon(Icons.broken_image),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                ),
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
                FutureBuilder<List<dynamic>>(
                  future: _mangaDexService.fetchChapters(mangaId, 'en,vi'),
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot,
                      ) {
                        if (!snapshot.hasData) {
                          return const SizedBox(
                            height: 50,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text('Không thể tải chapter');
                        }
                        final dynamic chapter = snapshot.data!.first;
                        final String chapterNumber =
                            (chapter['attributes']
                                    as Map<String, dynamic>)['chapter']
                                as String? ??
                            'N/A';
                        final String chapterTitle =
                            (chapter['attributes']
                                    as Map<String, dynamic>)['title']
                                as String? ??
                            '';
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChapterReaderScreen(
                                    chapter: Chapter(
                                      mangaId: mangaId,
                                      chapterId: chapter['id'] as String,
                                      chapterName: displayTitle,
                                      chapterList: snapshot.data!,
                                    ),
                                  ),
                            ),
                          ),
                        );
                      },
                ),
              ],
            ),
          ),
          if (isFollowing)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => handleUnfollow(mangaId),
            ),
        ],
      ),
    );
  }

  void dispose() {}
}
