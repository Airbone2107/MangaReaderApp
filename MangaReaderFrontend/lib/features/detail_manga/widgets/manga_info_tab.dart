import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/data/models/manga/manga_statistics.dart';
import 'package:manga_reader_app/data/models/manga/tag.dart';
import 'package:manga_reader_app/core/services/language_service.dart';
import 'package:manga_reader_app/utils/manga_helper.dart';

class MangaInfoTab extends StatelessWidget {
  final Manga manga;
  final MangaStatisticsData stats;
  const MangaInfoTab({super.key, required this.manga, required this.stats});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Mô tả'),
          Text(
            manga.getDisplayDescription(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 24),
          _buildInfoGrid(context),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Thể loại'),
          _buildTagsSection(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    final authors = manga.relationships
        .where((r) => r.type == 'author')
        .map((r) => (r.attributes?['name'] as String?) ?? 'N/A')
        .toSet()
        .join(', ');

    final artists = manga.relationships
        .where((r) => r.type == 'artist')
        .map((r) => (r.attributes?['name'] as String?) ?? 'N/A')
        .toSet()
        .join(', ');
        
    final numberFormatter = NumberFormat.decimalPattern('vi_VN');
    final String originalLanguageName = LanguageService.instance
        .getLanguageNameByCode(manga.attributes.originalLanguage);

    String statusDisplay = _capitalizeFirst(manga.attributes.status);
    String demographicDisplay =
        _capitalizeFirst(manga.attributes.publicationDemographic);
    String contentRatingDisplay =
        _capitalizeFirst(manga.attributes.contentRating);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // Giảm tỉ lệ để mỗi ô có chiều cao lớn hơn, tránh tràn nội dung khi tên dài
      childAspectRatio: 2.6,
      mainAxisSpacing: 12,
      crossAxisSpacing: 16,
      children: [
        _buildInfoItem(context, 'Tác giả', authors.isEmpty ? 'N/A' : authors),
        _buildInfoItem(context, 'Họa sĩ', artists.isEmpty ? 'N/A' : artists),
        _buildInfoItem(context, 'Năm phát hành', manga.attributes.year?.toString() ?? 'N/A'),
        _buildInfoItem(context, 'Trạng thái', statusDisplay),
        _buildInfoItem(context, 'Điểm TB', stats.rating.average?.toStringAsFixed(2) ?? 'N/A'),
        _buildInfoItem(context, 'Điểm Bayesian', stats.rating.bayesian.toStringAsFixed(2)),
        _buildInfoItem(context, 'Lượt theo dõi', numberFormatter.format(stats.follows)),
        _buildInfoItem(context, 'Đối tượng', demographicDisplay),
        _buildInfoItem(context, 'Ngôn ngữ gốc', originalLanguageName),
        _buildInfoItem(context, 'Đánh giá', contentRatingDisplay),
      ],
    );
  }

  String _capitalizeFirst(String? input) {
    if (input == null || input.isEmpty) return 'N/A';
    final lower = input.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: manga.attributes.tags.map((Tag tag) {
        return Chip(
          label: Text(tag.attributes.name['en'] ?? 'Unknown Tag'),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
        );
      }).toList(),
    );
  }
}


