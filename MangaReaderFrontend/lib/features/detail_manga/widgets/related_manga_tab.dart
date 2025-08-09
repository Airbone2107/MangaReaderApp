import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/data/models/manga/relationship.dart';
import 'package:manga_reader_app/data/services/mangadex_api_service.dart';
import 'package:manga_reader_app/features/detail_manga/view/manga_detail_screen.dart';
import 'package:manga_reader_app/shared_widgets/manga_card.dart';

class RelatedMangaTab extends StatefulWidget {
  final Manga manga;

  const RelatedMangaTab({super.key, required this.manga});

  @override
  State<RelatedMangaTab> createState() => _RelatedMangaTabState();
}

class _RelatedMangaTabState extends State<RelatedMangaTab> {
  late Future<List<Manga>> _relatedMangaDetailsFuture;
  late final List<Relationship> _mangaRelations;

  @override
  void initState() {
    super.initState();
    // Lọc và lưu trữ các mối quan hệ manga ngay từ đầu
    _mangaRelations = widget.manga.relationships
        .where((r) => r.type == 'manga')
        .toList();
    _relatedMangaDetailsFuture = _fetchRelatedMangaDetails();
  }

  /// Hàm gọi API để lấy chi tiết các manga liên quan
  Future<List<Manga>> _fetchRelatedMangaDetails() async {
    final mangaIds = _mangaRelations.map((r) => r.id).toList();

    if (mangaIds.isEmpty) {
      return [];
    }

    final apiService = MangaDexApiService();
    // Sử dụng hàm đã có để lấy manga theo danh sách ID
    return await apiService.fetchMangaByIds(mangaIds);
  }

  @override
  Widget build(BuildContext context) {
    if (_mangaRelations.isEmpty) {
      return const Center(
        child: Text('Không có truyện nào liên quan.'),
      );
    }

    return FutureBuilder<List<Manga>>(
      future: _relatedMangaDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải truyện liên quan: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không tìm thấy thông tin truyện liên quan.'));
        }

        final relatedMangasWithDetails = snapshot.data!;

        // Tạo một map để tra cứu loại quan hệ từ ID manga
        final mangaIdToRelationType = {
          for (var rel in _mangaRelations)
            rel.id: rel.related ?? 'related'
        };

        // Nhóm danh sách manga đã có đầy đủ thông tin theo loại quan hệ
        final groupedByRelation = relatedMangasWithDetails.groupListsBy(
              (manga) => mangaIdToRelationType[manga.id] ?? 'related',
        );

        final sortedKeys = groupedByRelation.keys.toList()..sort();

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: sortedKeys.length,
          itemBuilder: (context, index) {
            final relationType = sortedKeys[index];
            final mangasInGroup = groupedByRelation[relationType]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    relationType[0].toUpperCase() + relationType.substring(1).replaceAll('_', ' '),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: mangasInGroup.length,
                  itemBuilder: (gridContext, gridIndex) {
                    final relatedManga = mangasInGroup[gridIndex];
                    return GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MangaDetailScreen(mangaId: relatedManga.id),
                        ),
                      ),
                      child: MangaCard(manga: relatedManga, showOverlayTitle: false),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }
}


