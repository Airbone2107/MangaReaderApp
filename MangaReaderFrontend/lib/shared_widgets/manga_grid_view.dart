import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import '../data/models/sort_manga_model.dart';
import '../data/services/mangadex_api_service.dart';
import '../features/detail_manga/view/manga_detail_screen.dart';
import '../utils/logger.dart';

class MangaGridView extends StatefulWidget {
  final SortManga? sortManga;
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
  Map<String, String> coverCache = <String, String>{};
  int offset = 0;
  bool isLoading = false;

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

  Future<void> _loadMangas() async {
    if (isLoading) {
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
          for (final Manga manga in newMangas) {
            if (!mangas.any(
              (Manga existingManga) => existingManga.id == manga.id,
            )) {
              mangas.add(manga);
            }
          }
          offset += 21;
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

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _onScroll() {
    if (widget.controller.position.pixels >=
            widget.controller.position.maxScrollExtent - 200 &&
        !isLoading) {
      _loadMangas();
    }
  }

  Widget _buildCoverImage(String mangaId) {
    if (coverCache.containsKey(mangaId)) {
      return CachedNetworkImage(
        imageUrl: coverCache[mangaId]!,
        fit: BoxFit.cover,
        placeholder: (BuildContext context, String url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (BuildContext context, String url, dynamic error) =>
            const Icon(Icons.broken_image),
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

    return FutureBuilder<String>(
      future: _service.fetchCoverUrl(mangaId),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          coverCache[mangaId] = snapshot.data!;
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            fit: BoxFit.cover,
            placeholder: (BuildContext context, String url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (BuildContext context, String url, dynamic error) =>
                const Icon(Icons.broken_image),
            useOldImageOnUrlChange: true,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mangas.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
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
        final String mangaId = manga.id;
        final String title = manga.attributes.title['en'] ?? 'Không có tiêu đề';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    MangaDetailScreen(mangaId: mangaId),
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: _buildCoverImage(mangaId),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
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
        final String mangaId = manga.id;
        final String title = manga.attributes.title['en'] ?? 'Không có tiêu đề';
        final String description =
            manga.attributes.description['en'] ?? 'No description available';
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
                    MangaDetailScreen(mangaId: mangaId),
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
                    child: _buildCoverImage(mangaId),
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
