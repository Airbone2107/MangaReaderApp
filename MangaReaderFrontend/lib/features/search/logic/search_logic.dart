import 'package:flutter/material.dart';
import '../../../data/models/manga/tag.dart';
import '../../../data/services/mangadex_api_service.dart';
import '../../../utils/logger.dart';
import '../view/manga_list_search.dart';
import '../../../data/models/sort_manga_model.dart';

class SearchLogic {
  final MangaDexApiService _service = MangaDexApiService();
  final TextEditingController searchController = TextEditingController();

  Set<String> selectedTags = <String>{};
  Set<String> excludedTags = <String>{};
  String safetyFilter = 'Tất cả';
  String statusFilter = 'Tất cả';
  String demographicFilter = 'Tất cả';
  String sortBy = 'Mới cập nhật';

  bool isLoading = false;
  List<Tag> availableTags = <Tag>[];

  late BuildContext context;
  late VoidCallback refreshUI;

  void init(BuildContext context, VoidCallback refreshUI) {
    this.context = context;
    this.refreshUI = refreshUI;
    _loadTags();
  }

  Future<void> _loadTags() async {
    try {
      final List<Tag> tags = await _service.fetchTags();
      // Tạo một bản sao có thể thay đổi của danh sách
      availableTags = List<Tag>.from(tags);

      // Bây giờ có thể sắp xếp danh sách đã được sao chép
      availableTags.sort((Tag a, Tag b) {
        final int groupCompare = a.attributes.group.compareTo(
          b.attributes.group,
        );
        return groupCompare != 0
            ? groupCompare
            : (a.attributes.name['en'] ?? '').compareTo(
                b.attributes.name['en'] ?? '',
              );
      });
      refreshUI();
    } catch (e, s) {
      logger.e('Lỗi khi tải tags', error: e, stackTrace: s);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không tải được danh sách tags. Vui lòng thử lại!'),
          ),
        );
      }
    }
  }

  void onTagIncludePressed(Tag tag) {
    if (excludedTags.contains(tag.id)) {
      excludedTags.remove(tag.id);
    }
    selectedTags.contains(tag.id)
        ? selectedTags.remove(tag.id)
        : selectedTags.add(tag.id);
    refreshUI();
  }

  void onTagExcludePressed(Tag tag) {
    if (selectedTags.contains(tag.id)) {
      selectedTags.remove(tag.id);
    }
    excludedTags.contains(tag.id)
        ? excludedTags.remove(tag.id)
        : excludedTags.add(tag.id);
    refreshUI();
  }

  Future<void> performSearch() async {
    isLoading = true;
    refreshUI();

    final SortManga sortManga = SortManga(
      title: searchController.text.trim(),
      includedTags: selectedTags.toList(),
      excludedTags: excludedTags.toList(),
      safety: safetyFilter,
      status: statusFilter,
      demographic: demographicFilter,
      sortBy: sortBy,
    );

    isLoading = false;
    refreshUI();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            MangaListSearch(sortManga: sortManga),
      ),
    );
  }

  void dispose() {
    searchController.dispose();
  }
}
