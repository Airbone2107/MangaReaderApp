import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/data/models/sort_manga_model.dart';
import 'package:manga_reader_app/features/detail_manga/view/manga_detail_screen.dart';
import 'package:manga_reader_app/features/home/logic/home_providers.dart';
import 'package:manga_reader_app/features/search/view/manga_search_screen.dart';

import '../../../utils/manga_helper.dart';

class TabContentView extends ConsumerWidget {
  final MangaSearchQuery sortManga;
  final bool isActive;
  const TabContentView({super.key, required this.sortManga, required this.isActive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isActive) {
      return CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          const SliverToBoxAdapter(child: SizedBox.shrink()),
        ],
      );
    }

    final mangaListAsync = ref.watch(tabContentProvider(sortManga));

    return mangaListAsync.when(
      data: (mangas) => CustomScrollView(
        slivers: [
          // Đồng bộ vùng chồng lấp với SliverAppBar của NestedScrollView
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final manga = mangas[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MangaDetailScreen(mangaId: manga.id),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildCoverImage(manga),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
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
                                manga.getDisplayTitle(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
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
                childCount: mangas.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdvancedSearchScreen(
                        initialFilters: sortManga,
                      ),
                    ),
                  );
                },
                child: const Text('Xem tất cả'),
              ),
            ),
          )
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Đã xảy ra lỗi khi tải. Vui lòng thử lại.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                // Làm mới provider theo tham số để gọi lại API
                ref.invalidate(tabContentProvider(sortManga));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tải lại'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCoverImage(Manga manga) {
  String? coverFileName;
  try {
    final coverArtRelationship =
        manga.relationships.firstWhere((rel) => rel.type == 'cover_art');
    coverFileName = coverArtRelationship.attributes?['fileName'] as String?;
  } catch (_) {
    coverFileName = null;
  }

  if (coverFileName != null) {
    final String imageUrl =
        'https://uploads.mangadex.org/covers/${manga.id}/$coverFileName.512.jpg';
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          Image.asset('assets/placeholder.png', fit: BoxFit.cover),
    );
  }

  return Image.asset('assets/placeholder.png', fit: BoxFit.cover);
}