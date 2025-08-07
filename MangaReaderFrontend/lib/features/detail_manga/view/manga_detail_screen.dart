import 'package:flutter/material.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/models/manga/manga.dart';
import '../../../data/models/manga/relationship.dart';
import '../../../data/models/manga/tag.dart';
import '../../chapter_reader/view/chapter_reader_screen.dart';
import '../logic/manga_detail_logic.dart';

class MangaDetailScreen extends StatefulWidget {
  final String mangaId;
  const MangaDetailScreen({super.key, required this.mangaId});

  @override
  State<MangaDetailScreen> createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen> {
  late MangaDetailLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = MangaDetailLogic(
      mangaId: widget.mangaId,
      refreshUI: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Manga'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _logic.isFollowing ? Icons.bookmark : Icons.bookmark_outline,
              color: _logic.isFollowing ? Colors.green : Colors.white,
            ),
            onPressed: () => _logic.toggleFollowStatus(context),
          ),
        ],
      ),
      body: FutureBuilder<Manga>(
        future: _logic.mangaDetails,
        builder: (BuildContext context, AsyncSnapshot<Manga> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu'));
          } else {
            return _buildContent(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildContent(Manga details) {
    final Manga manga = details;
    final String title = manga.attributes.title['en'] ?? 'Không có tiêu đề';
    final String description =
        manga.attributes.description['en'] ?? 'Không có mô tả';

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder<String>(
                future: _logic.coverUrl,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<String> coverSnapshot,
                    ) {
                      if (coverSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 150,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (coverSnapshot.hasError) {
                        return const Icon(Icons.broken_image, size: 100);
                      } else {
                        return Image.network(
                          coverSnapshot.data!,
                          width: MediaQuery.of(context).size.width / 3,
                          height: 150,
                          fit: BoxFit.cover,
                        );
                      }
                    },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showFullDetailsDialog(manga),
                      child: Text(
                        description,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(child: _buildChapterList()),
      ],
    );
  }

  void _showFullDetailsDialog(Manga manga) {
    final String description =
        manga.attributes.description['en'] ?? 'Không có mô tả';
    final String status = manga.attributes.status ?? 'Không xác định';
    final List<String> tags = manga.attributes.tags
        .map((Tag tag) => tag.attributes.name['en'] ?? 'Không rõ')
        .toList();

    final List<Relationship> authors = manga.relationships
        .where((Relationship r) => r.type == 'author')
        .toList();

    final String authorNames = authors.isNotEmpty
        ? authors
              .map(
                (Relationship author) =>
                    (author.attributes?['name'] as String?) ?? 'Không rõ',
              )
              .join(', ')
        : 'Không rõ';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: <Widget>[
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8),
              Text('Thông tin chi tiết'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'Tác giả:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(authorNames),
                const SizedBox(height: 8),
                const Text(
                  'Mô tả:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(description),
                const SizedBox(height: 8),
                const Text(
                  'Trạng thái:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(status),
                const SizedBox(height: 8),
                const Text(
                  'Thể loại:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...tags.map((String tag) => Text('- $tag')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChapterList() {
    return FutureBuilder<List<dynamic>>(
      future: _logic.chapters,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có chương nào.'));
        } else {
          final List<dynamic> chapterList = snapshot.data!;
          final Map<String, List<dynamic>> chaptersByLanguage =
              <String, List<dynamic>>{};
          for (final dynamic chapter in chapterList) {
            final String lang =
                (chapter['attributes']['translatedLanguage'] as String?) ??
                'Unknown';
            chaptersByLanguage
                .putIfAbsent(lang, () => <dynamic>[])
                .add(chapter);
          }

          return ListView(
            children: chaptersByLanguage.entries.map((
              MapEntry<String, List<dynamic>> langEntry,
            ) {
              final String language = langEntry.key;
              final List<dynamic> languageChapters = langEntry.value;
              return ExpansionTile(
                title: Text('Ngôn ngữ: ${language.toUpperCase()}'),
                children: languageChapters.map<Widget>((dynamic chapter) {
                  final Map<String, dynamic> attributes =
                      chapter['attributes'] as Map<String, dynamic>;
                  final String chapterTitle =
                      (attributes['title'] as String?) ?? '';
                  final String chapterNumber =
                      (attributes['chapter'] as String?) ?? 'N/A';
                  final String displayTitle =
                      chapterTitle.isEmpty || chapterTitle == chapterNumber
                      ? 'Chương $chapterNumber'
                      : 'Chương $chapterNumber: $chapterTitle';

                  return ListTile(
                    title: Text(displayTitle),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ChapterReaderScreen(
                          chapter: Chapter(
                            mangaId: widget.mangaId,
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
        }
      },
    );
  }
}
