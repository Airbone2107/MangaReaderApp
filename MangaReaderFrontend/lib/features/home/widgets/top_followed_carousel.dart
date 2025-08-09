import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/features/detail_manga/view/manga_detail_screen.dart';
import 'package:manga_reader_app/features/home/logic/home_providers.dart';
import 'package:manga_reader_app/utils/manga_helper.dart';
class TopFollowedCarousel extends ConsumerStatefulWidget {
  const TopFollowedCarousel({super.key});

  @override
  ConsumerState<TopFollowedCarousel> createState() => _TopFollowedCarouselState();
}

class _TopFollowedCarouselState extends ConsumerState<TopFollowedCarousel> {
  // Dùng initialPage lớn để cho phép kéo vòng lặp cả hai chiều
  final PageController _pageController =
      PageController(viewportFraction: 0.9, initialPage: 10000);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncMangas = ref.watch(topDailyFollowedMangaProvider);
    return asyncMangas.when(
      data: (mangas) => _buildCarousel(context, mangas.take(10).toList()),
      loading: () => const SizedBox(
        height: 210,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => SizedBox(
        height: 210,
        child: Center(child: Text('Lỗi tải carousel: $err')),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, List<Manga> mangas) {
    if (mangas.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final int safeLen = mangas.length;
          final int modIndex = ((index % safeLen) + safeLen) % safeLen;
          final manga = mangas[modIndex];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _CarouselCard(manga: manga),
          );
        },
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final Manga manga;
  const _CarouselCard({required this.manga});

  @override
  Widget build(BuildContext context) {
    String? coverFileName;
    try {
      final coverArtRelationship =
          manga.relationships.firstWhere((rel) => rel.type == 'cover_art');
      coverFileName = coverArtRelationship.attributes?['fileName'] as String?;
    } catch (_) {
      coverFileName = null;
    }

    final String? imageUrl = coverFileName != null
        ? 'https://uploads.mangadex.org/covers/${manga.id}/$coverFileName.512.jpg'
        : null;

    final List<String> tags = manga.attributes.tags
        .map((t) => t.attributes.name['en'] ?? '')
        .where((e) => e.isNotEmpty)
        .take(2)
        .toList();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaDetailScreen(mangaId: manga.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: SizedBox(
                width: 120,
                height: 200,
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset('assets/placeholder.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      manga.getDisplayTitle(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      manga.getDisplayDescription(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    if (tags.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: tags
                            .map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(fontSize: 11),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}


