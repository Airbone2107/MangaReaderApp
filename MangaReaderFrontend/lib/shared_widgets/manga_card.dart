import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/utils/manga_helper.dart';

class MangaCard extends StatelessWidget {
  final Manga manga;
  // Hiển thị tiêu đề đè lên ảnh với lớp làm mờ cục bộ phía dưới tiêu đề
  final bool showOverlayTitle;

  const MangaCard({
    super.key,
    required this.manga,
    this.showOverlayTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final String title = manga.getDisplayTitle();
    String? coverFileName;
    try {
      final coverArtRelationship =
          manga.relationships.firstWhere((rel) => rel.type == 'cover_art');
      coverFileName = coverArtRelationship.attributes?['fileName'] as String?;
    } catch (e) {
      coverFileName = null;
    }

    final imageUrl = coverFileName != null
        ? 'https://uploads.mangadex.org/covers/${manga.id}/$coverFileName.512.jpg'
        : null;

    final imageWidget = imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                Image.asset('assets/placeholder.png', fit: BoxFit.cover),
          )
        : Image.asset('assets/placeholder.png', fit: BoxFit.cover);

    if (showOverlayTitle) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageWidget,
            // Thanh tiêu đề ở dưới cùng với làm mờ cục bộ phía sau
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BlurTitleBar(title: title),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Column(
        children: [
          Expanded(child: imageWidget),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _BlurTitleBar extends StatelessWidget {
  final String title;
  const _BlurTitleBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          color: Colors.black.withOpacity(0.38),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}

class MangaListTile extends StatelessWidget {
  final Manga manga;
  const MangaListTile({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    final title = manga.getDisplayTitle();
    final description = manga.getDisplayDescription();
    final tags = manga.attributes.tags
        .map((tag) => tag.attributes.name['en'] ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 80,
            height: 120,
            child: MangaCard(manga: manga),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: tags.take(3).map((tag) {
                    return Chip(
                      label: Text(tag, style: const TextStyle(fontSize: 10)),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


