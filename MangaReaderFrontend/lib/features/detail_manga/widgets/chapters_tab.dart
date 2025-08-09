import 'package:flutter/material.dart';
import 'package:manga_reader_app/data/models/chapter_model.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/data/models/manga/relationship.dart';
import 'package:manga_reader_app/features/chapter_reader/view/chapter_reader_screen.dart';
import 'package:manga_reader_app/utils/manga_helper.dart';

class ChaptersTab extends StatelessWidget {
  final Manga manga;
  final Future<List<dynamic>> chaptersFuture;

  const ChaptersTab({
    super.key,
    required this.manga,
    required this.chaptersFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildHeader(context),
        const Divider(),
        Expanded(child: _buildChapterList()),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final String title = manga.getDisplayTitle();
    final String description = manga.getDisplayDescription();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCoverImage(context),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    String? coverFileName;
    try {
      final Relationship coverArtRelationship =
          manga.relationships.firstWhere((rel) => rel.type == 'cover_art');
      coverFileName =
          (coverArtRelationship.attributes?['fileName'] as String?);
    } catch (e) {
      coverFileName = null;
    }

    return SizedBox(
      width: 120,
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: coverFileName != null
            ? Image.network(
                'https://uploads.mangadex.org/covers/${manga.id}/$coverFileName.512.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 100),
              )
            : const Icon(Icons.broken_image, size: 100),
      ),
    );
  }

  Widget _buildChapterList() {
    return FutureBuilder<List<dynamic>>(
      future: chaptersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có chương nào.'));
        }

        final chapterList = snapshot.data!;
        final chaptersByLanguage = <String, List<dynamic>>{};
        for (final chapter in chapterList) {
          final lang =
              (chapter['attributes']['translatedLanguage'] as String?) ??
                  'Unknown';
          chaptersByLanguage.putIfAbsent(lang, () => []).add(chapter);
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: chaptersByLanguage.entries.map((langEntry) {
            final language = langEntry.key;
            final languageChapters = langEntry.value;
            return ExpansionTile(
              title: Text('Ngôn ngữ: ${language.toUpperCase()}'),
              initiallyExpanded: true,
              children: languageChapters.map<Widget>((chapter) {
                final attributes = chapter['attributes'] as Map<String, dynamic>;
                final chapterTitle = attributes['title'] as String? ?? '';
                final chapterNumber = attributes['chapter'] as String? ?? 'N/A';
                final displayTitle =
                    chapterTitle.isEmpty || chapterTitle == chapterNumber
                        ? 'Chương $chapterNumber'
                        : 'Chương $chapterNumber: $chapterTitle';

                return ListTile(
                  title: Text(displayTitle),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChapterReaderScreen(
                        chapter: Chapter(
                          mangaId: manga.id,
                          chapterId: chapter['id'] as String,
                          chapterName: displayTitle,
                          chapterList: languageChapters,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }
}


