import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/models/manga/manga.dart';
import '../../../core/services/language_service.dart';
import '../../../data/models/manga/relationship.dart';
import '../../chapter_reader/view/chapter_reader_screen.dart';
import '../../../utils/manga_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChaptersTab extends StatefulWidget {
  final Manga manga;
  final Future<List<dynamic>> chaptersFuture;

  const ChaptersTab({
    super.key,
    required this.manga,
    required this.chaptersFuture,
  });

  @override
  State<ChaptersTab> createState() => _ChaptersTabState();
}

class _ChaptersTabState extends State<ChaptersTab> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, bool> _expandedLanguage = <String, bool>{};
  final Map<String, Map<String, bool>> _expandedVolume =
      <String, Map<String, bool>>{};

  // Header alignment helpers
  static const double _languageHeaderHeight = 48.0;
  static const double _volumeHeaderHeight = 44.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    return _buildChapterList();
  }

  Widget _buildHeader(
    BuildContext context, {
    required VoidCallback onReadFirst,
    required VoidCallback onReadLatest,
  }) {
    final String title = widget.manga.getDisplayTitle();
    final String description = widget.manga.getDisplayDescription();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Hàng 1: Tên Manga
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Hàng 2: Cover + Mô tả
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildCoverImage(context),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Hàng 3: 2 nút dưới cả Cover và Mô tả
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: onReadFirst,
                icon: const Icon(Icons.first_page),
                label: const Text('Bắt Đầu'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onReadLatest,
                icon: const Icon(Icons.new_releases),
                label: const Text('Mới Nhất'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Hàm so sánh cho chapter (string -> double)
  int _compareChapter(dynamic a, dynamic b) {
    final aNum =
        double.tryParse(a['attributes']['chapter'] as String? ?? '-1') ?? -1;
    final bNum =
        double.tryParse(b['attributes']['chapter'] as String? ?? '-1') ?? -1;
    return bNum.compareTo(aNum);
  }

  // Hàm so sánh cho volume (string -> double)
  int _compareVolume(String a, String b) {
    if (a == 'none') return -1;
    if (b == 'none') return 1;
    final aNum = double.tryParse(a) ?? -1;
    final bNum = double.tryParse(b) ?? -1;
    return bNum.compareTo(aNum);
  }

  Widget _buildCoverImage(BuildContext context) {
    String? coverFileName;
    try {
      final Relationship coverArtRelationship =
          widget.manga.relationships.firstWhere((rel) => rel.type == 'cover_art');
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
            ? GestureDetector(
                onTap: () {
                  final String urlLarge =
                      'https://uploads.mangadex.org/covers/${widget.manga.id}/$coverFileName';
                  _showCoverPreview(context, urlLarge);
                },
                child: Image.network(
                  'https://uploads.mangadex.org/covers/${widget.manga.id}/$coverFileName.512.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              )
            : const Icon(Icons.broken_image, size: 100),
      ),
    );
  }

  Widget _buildChapterList() {
    return FutureBuilder<List<dynamic>>(
      future: widget.chaptersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có chương nào.'));
        }

        final chapterList = snapshot.data!;
        final chaptersByLanguage = groupBy(
          chapterList,
          (dynamic chapter) =>
              (chapter['attributes']['translatedLanguage'] as String?) ??
              'Unknown',
        );

        // Chuẩn bị map chương đầu tiên và mới nhất theo từng ngôn ngữ
        final Map<String, dynamic> firstChapterByLanguage = <String, dynamic>{};
        final Map<String, dynamic> latestChapterByLanguage = <String, dynamic>{};
        chaptersByLanguage.forEach((String lang, List<dynamic> list) {
          dynamic first;
          dynamic latest;
          double? minVal;
          double? maxVal;
          for (final dynamic ch in list) {
            final String? numStr = (ch['attributes']['chapter'] as String?);
            if (numStr == null) continue;
            final double? v = double.tryParse(numStr);
            if (v == null) continue;
            if (minVal == null || v < minVal) {
              minVal = v;
              first = ch;
            }
            if (maxVal == null || v > maxVal) {
              maxVal = v;
              latest = ch;
            }
          }
          if (first != null) firstChapterByLanguage[lang] = first!;
          if (latest != null) latestChapterByLanguage[lang] = latest!;
        });

        // Xây dựng danh sách Sliver: header (cover/mô tả) + headers + list
        final List<Widget> slivers = <Widget>[
          SliverToBoxAdapter(
            child: _buildHeader(
              context,
              onReadFirst: () => _showChapterPickerDialog(
                context,
                isLatest: false,
                chapterByLanguage: firstChapterByLanguage,
                chaptersByLanguage: chaptersByLanguage,
              ),
              onReadLatest: () => _showChapterPickerDialog(
                context,
                isLatest: true,
                chapterByLanguage: latestChapterByLanguage,
                chaptersByLanguage: chaptersByLanguage,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Divider(height: 1)),
        ];

        chaptersByLanguage.entries.forEach((langEntry) {
          final String languageCode = langEntry.key;
          final List<dynamic> languageChapters = langEntry.value;
          final String languageName =
              LanguageService.instance.getLanguageNameByCode(languageCode);
          final String? flagAsset = LanguageService.instance
              .getFlagAssetByLanguageCode(languageCode);

          // Khởi tạo trạng thái mở rộng mặc định nếu chưa có
          _expandedLanguage.putIfAbsent(languageCode, () => false);
          _expandedVolume.putIfAbsent(languageCode, () => <String, bool>{});

          final Map<String, List<dynamic>> chaptersByVolume = groupBy(
            languageChapters,
            (dynamic chapter) =>
                chapter['attributes']['volume'] as String? ?? 'none',
          );

          final List<String> sortedVolumeKeys = chaptersByVolume.keys.toList()
            ..sort(_compareVolume);

          final String languageRangeLabel = _getChapterRangeLabel(languageChapters);

          // Header ngôn ngữ
          slivers.add(
            SliverToBoxAdapter(
              child: _buildLanguageHeader(
                languageCode: languageCode,
                languageName: languageName,
                flagAsset: flagAsset,
                totalChapters: languageChapters.length,
                rangeLabel: languageRangeLabel,
              ),
            ),
          );

          if (_expandedLanguage[languageCode] == true) {
            // Headers Volume
            for (final String volumeKey in sortedVolumeKeys) {
              final List<dynamic> volumeChapters =
                  (chaptersByVolume[volumeKey]!..sort(_compareChapter));

              _expandedVolume[languageCode]!
                  .putIfAbsent(volumeKey, () => false);

              slivers.add(
                SliverToBoxAdapter(
                  child: _buildVolumeHeader(
                    languageCode: languageCode,
                    volumeKey: volumeKey,
                    totalChapters: volumeChapters.length,
                    rangeLabel: _getChapterRangeLabel(volumeChapters),
                  ),
                ),
              );

              if (_expandedVolume[languageCode]![volumeKey] == true) {
                slivers.add(
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildChapterTile(
                        context,
                        volumeChapters[index],
                        languageChapters,
                      ),
                      childCount: volumeChapters.length,
                    ),
                  ),
                );
              }
            }
          }
        });

        return CustomScrollView(
          controller: _scrollController,
          slivers: slivers,
        );
      },
    );
  }

  Widget _buildChapterTile(
    BuildContext context,
    dynamic chapterData,
    List<dynamic> fullLanguageChapterList,
  ) {
    final attributes = chapterData['attributes'] as Map<String, dynamic>;
    final chapterTitle = attributes['title'] as String? ?? '';
    final chapterNumber = attributes['chapter'] as String? ?? 'N/A';
    final displayTitle = chapterTitle.isEmpty || chapterTitle == chapterNumber
        ? 'Chương $chapterNumber'
        : 'Chương $chapterNumber: $chapterTitle';

    final relationships = (chapterData['relationships'] as List<dynamic>?)
            ?.map((r) => Relationship.fromJson(r as Map<String, dynamic>))
            .toList() ??
        [];

    final groups = relationships
        .where((r) => r.type == 'scanlation_group')
        .map((r) => (r.attributes?['name'] as String?) ?? 'N/A')
        .join(', ');

    final uploader = relationships
        .firstWhereOrNull((r) => r.type == 'user')
        ?.attributes?['username'] as String?;

    final String timeText = _formatTime(attributes['updatedAt'] as String?);

    return ListTile(
      title: Text(displayTitle),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 2,
                children: [
                  if (groups.isNotEmpty) ...[
                    const Icon(Icons.group, size: 14, color: Colors.black54),
                    Text(
                      groups,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (uploader != null) ...[
                    const Icon(Icons.person, size: 14, color: Colors.black54),
                    Text(
                      uploader,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (timeText.isNotEmpty)
              Text(
                timeText,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
          ],
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChapterReaderScreen(
            chapter: Chapter(
              mangaId: widget.manga.id,
              chapterId: chapterData['id'] as String,
              chapterName: displayTitle,
              chapterList: fullLanguageChapterList,
            ),
          ),
        ),
      ),
    );
  }

  // Header ngôn ngữ
  Widget _buildLanguageHeader({
    required String languageCode,
    required String languageName,
    required String? flagAsset,
    required int totalChapters,
    required String rangeLabel,
  }) {
    final bool isExpanded = _expandedLanguage[languageCode] ?? false;
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: () {
          setState(() {
            _expandedLanguage[languageCode] = !isExpanded;
          });
        },
        child: SizedBox(
          height: _languageHeaderHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Centered range label (absolute center)
                IgnorePointer(
                  child: Text(
                    rangeLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                // Row for left/right content
                Row(
                  children: [
                    if (flagAsset != null)
                      SvgPicture.asset(
                        flagAsset,
                        width: 24,
                        height: 18,
                        fit: BoxFit.cover,
                      ),
                    if (flagAsset != null) const SizedBox(width: 8),
                    Text(
                      languageName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      '$totalChapters',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 6),
                    Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header volume
  Widget _buildVolumeHeader({
    required String languageCode,
    required String volumeKey,
    required int totalChapters,
    required String rangeLabel,
  }) {
    final bool isExpanded = _expandedVolume[languageCode]?[volumeKey] ?? false;
    final String title = volumeKey == 'none' ? 'Chưa sắp xếp' : 'Volume $volumeKey';
    return Material(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () {
          setState(() {
            _expandedVolume[languageCode]![volumeKey] = !isExpanded;
          });
        },
        child: SizedBox(
          height: _volumeHeaderHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Centered range label
                IgnorePointer(
                  child: Text(
                    rangeLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    Text('$totalChapters', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 6),
                    Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper: Format thời gian (>= 30 ngày hiển thị ngày cụ thể)
  String _formatTime(String? isoString) {
    if (isoString == null) return '';
    final DateTime? dt = DateTime.tryParse(isoString)?.toLocal();
    if (dt == null) return '';
    final Duration diff = DateTime.now().difference(dt);
    if (diff.inDays >= 30) {
      return _formatDate(dt);
    }
    return timeago.format(dt, locale: 'vi');
  }

  String _formatDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}';
  }

  String _getChapterRangeLabel(List<dynamic> chapters) {
    double? minVal;
    double? maxVal;
    for (final dynamic ch in chapters) {
      final String? numStr = (ch['attributes']['chapter'] as String?);
      if (numStr == null) continue;
      final double? val = double.tryParse(numStr);
      if (val == null) continue;
      if (minVal == null || val < minVal) minVal = val;
      if (maxVal == null || val > maxVal) maxVal = val;
    }
    if (minVal == null || maxVal == null) return '';
    if (minVal == maxVal) return 'Ch. ${_formatChapterNumber(minVal)}';
    return 'Ch. ${_formatChapterNumber(minVal)}-${_formatChapterNumber(maxVal)}';
  }

  String _formatChapterNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
  void _showCoverPreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black87,
      builder: (ctx) {
        return GestureDetector(
          onTap: () => Navigator.of(ctx).pop(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: Colors.white70,
                      size: 120,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showChapterPickerDialog(
    BuildContext context, {
    required bool isLatest,
    required Map<String, dynamic> chapterByLanguage,
    required Map<String, List<dynamic>> chaptersByLanguage,
  }) async {
    if (chapterByLanguage.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isLatest ? 'Không có chương mới nhất khả dụng.' : 'Không có chương đầu tiên khả dụng.')),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetCtx) {
        final entries = chapterByLanguage.entries.toList()
          ..sort((a, b) => LanguageService.instance
              .getLanguageNameByCode(a.key)
              .compareTo(LanguageService.instance.getLanguageNameByCode(b.key)));
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    isLatest ? 'Chọn ngôn ngữ để đọc chương mới nhất' : 'Chọn ngôn ngữ để đọc chương đầu tiên',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      final entry = entries[index];
                      final String languageCode = entry.key;
                      final dynamic chapterData = entry.value;
                      final String languageName = LanguageService.instance.getLanguageNameByCode(languageCode);
                      final String? flagAsset = LanguageService.instance.getFlagAssetByLanguageCode(languageCode);
                      final String displayTitle = _buildDisplayTitle(chapterData);
                      return ListTile(
                        leading: flagAsset != null
                            ? SvgPicture.asset(flagAsset, width: 28, height: 20, fit: BoxFit.cover)
                            : const SizedBox(width: 28),
                        title: Text(languageName),
                        subtitle: Text(displayTitle),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(sheetCtx).pop();
                          final List<dynamic> fullLangList = chaptersByLanguage[languageCode] ?? <dynamic>[];
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChapterReaderScreen(
                                chapter: Chapter(
                                  mangaId: widget.manga.id,
                                  chapterId: chapterData['id'] as String,
                                  chapterName: displayTitle,
                                  chapterList: fullLangList,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: entries.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _buildDisplayTitle(dynamic chapterData) {
    final attributes = chapterData['attributes'] as Map<String, dynamic>;
    final chapterTitle = attributes['title'] as String? ?? '';
    final chapterNumber = attributes['chapter'] as String? ?? 'N/A';
    return chapterTitle.isEmpty || chapterTitle == chapterNumber
        ? 'Chương $chapterNumber'
        : 'Chương $chapterNumber: $chapterTitle';
  }
}


