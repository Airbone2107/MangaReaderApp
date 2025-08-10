import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../data/models/manga/manga.dart';
import '../data/models/manga/relationship.dart';
import '../data/models/sort_manga_model.dart';
import '../data/services/mangadex_api_service.dart';
import '../features/detail_manga/view/manga_detail_screen.dart';
import '../utils/logger.dart';
import '../utils/manga_helper.dart';

/// Lưới hoặc danh sách hiển thị manga với lazy-loading.
class MangaGridView extends StatefulWidget {
  final MangaSearchQuery? sortManga;
  final ScrollController controller;
  final bool isGridView;

  const MangaGridView({
    super.key,
    this.sortManga,
    required this.controller,
    required this.isGridView,
  });

  @override
  State<MangaGridView> createState() => _MangaGridViewState();
}

class _MangaGridViewState extends State<MangaGridView> {
  final MangaDexApiService _service = MangaDexApiService();
  List<Manga> mangas = <Manga>[];
  int offset = 0;
  bool isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMangas();
    widget.controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant MangaGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  /// Tải danh sách manga theo trang, tránh trùng nếu đã có.
  Future<void> _loadMangas() async {
    if (isLoading || !_hasMore) {
      return;
    }
    if (mounted) {
      setState(() => isLoading = true);
    }

    try {
      final List<Manga> newMangas = await _service.fetchManga(
        limit: 21,
        offset: offset,
        sortManga: widget.sortManga,
      );
      if (mounted) {
        setState(() {
          if (newMangas.length < 21) {
            _hasMore = false;
          }
          for (final Manga manga in newMangas) {
            if (!mangas.any(
                  (Manga existingManga) => existingManga.id == manga.id,
            )) {
              mangas.add(manga);
            }
          }
          offset += newMangas.length;
        });
      }
    } catch (e, s) {
      if (mounted) {
        _showErrorMessage(e.toString());
      }
      logger.e('Lỗi khi tải manga', error: e, stackTrace: s);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  /// Hiển thị snackbar lỗi nếu đang mounted.
  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  /// Lắng nghe cuộn để tự động tải thêm khi gần cuối danh sách.
  void _onScroll() {
    if (widget.controller.position.pixels >=
        widget.controller.position.maxScrollExtent - 200 &&
        !isLoading) {
      _loadMangas();
    }
  }

  /// Dựng ảnh bìa cho một phần tử manga.
  Widget _buildCoverImage(Manga manga) {
    String? coverFileName;
    try {
      final Relationship coverArtRelationship =
      manga.relationships.firstWhere((rel) => rel.type == 'cover_art');
      if (coverArtRelationship.attributes != null) {
        coverFileName =
        coverArtRelationship.attributes!['fileName'] as String?;
      }
    } catch (e) {
      coverFileName = null;
    }

    if (coverFileName != null) {
      final String imageUrl =
          'https://uploads.mangadex.org/covers/${manga.id}/$coverFileName.512.jpg';
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (BuildContext context, String url) =>
        const Center(child: CircularProgressIndicator()),
        errorWidget: (BuildContext context, String url, dynamic error) =>
            Image.asset('assets/placeholder.png', fit: BoxFit.cover),
        useOldImageOnUrlChange: true,
        cacheManager: CacheManager(
          Config(
            'customCacheKey',
            stalePeriod: const Duration(days: 0),
            maxNrOfCacheObjects: 231,
          ),
        ),
      );
    }

    return Image.asset('assets/placeholder.png', fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    if (mangas.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
     if (mangas.isEmpty && !isLoading) {
      return const Center(child: Text("Không tìm thấy kết quả phù hợp."));
    }
    return widget.isGridView ? _buildGridView() : _buildListView();
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: widget.controller,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.7,
      ),
      itemCount: mangas.length + (isLoading ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index >= mangas.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final Manga manga = mangas[index];

        final String title = manga.getDisplayTitle();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    MangaDetailScreen(mangaId: manga.id),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _buildCoverImage(manga),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.00),
                          Colors.black.withOpacity(0.22),
                          Colors.black.withOpacity(0.42),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: widget.controller,
      itemCount: mangas.length + (isLoading ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index >= mangas.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final Manga manga = mangas[index];
        final String title = manga.getDisplayTitle();
        final String description = manga.getDisplayDescription();
        final List<String> tags = manga.attributes.tags
            .map((tag) => tag.attributes.name['en'] ?? '')
            .where((name) => name.isNotEmpty)
            .toList();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    MangaDetailScreen(mangaId: manga.id),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 120,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: _buildCoverImage(manga),
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
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: tags.take(3).map((String tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}