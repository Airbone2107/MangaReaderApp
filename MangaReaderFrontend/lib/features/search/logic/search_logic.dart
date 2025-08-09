import 'package:flutter/material.dart';
import '../../../data/models/manga/tag.dart';
import '../../../data/services/mangadex_api_service.dart';
import '../../../utils/logger.dart';
import '../view/manga_list_search.dart';
import '../../../data/models/sort_manga_model.dart';

/// Nghiệp vụ cho màn hình tìm kiếm nâng cao.
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

  /// Khởi tạo context và tải danh sách tags.
  void init(
    BuildContext context,
    VoidCallback refreshUI, {
    SortManga? initialSortManga,
  }) {
    this.context = context;
    this.refreshUI = refreshUI;
    if (initialSortManga != null) {
      _applyInitialFilters(initialSortManga);
    }
    _loadTags();
  }

  void _applyInitialFilters(SortManga filters) {
    if (filters.publicationDemographic != null &&
        filters.publicationDemographic!.isNotEmpty) {
      demographicFilter = filters.publicationDemographic!.first;
    }
    if (filters.status != null && filters.status!.isNotEmpty) {
      statusFilter = filters.status!.first;
    }
    refreshUI();
  }

  /// Tải, sắp xếp và lưu danh sách tags khả dụng.
  Future<void> _loadTags() async {
    try {
      final List<Tag> tags = await _service.fetchTags();
      availableTags = List<Tag>.from(tags);

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

  /// Thêm/bỏ một tag khỏi danh sách bao gồm.
  void onTagIncludePressed(Tag tag) {
    if (excludedTags.contains(tag.id)) {
      excludedTags.remove(tag.id);
    }
    selectedTags.contains(tag.id)
        ? selectedTags.remove(tag.id)
        : selectedTags.add(tag.id);
    refreshUI();
  }

  /// Thêm/bỏ một tag khỏi danh sách loại trừ.
  void onTagExcludePressed(Tag tag) {
    if (selectedTags.contains(tag.id)) {
      selectedTags.remove(tag.id);
    }
    excludedTags.contains(tag.id)
        ? excludedTags.remove(tag.id)
        : excludedTags.add(tag.id);
    refreshUI();
  }

  /// Trả về map sắp xếp theo lựa chọn hiện tại.
  Map<String, SortOrder> _getSortOrder() {
    switch (sortBy) {
      case 'Truyện mới':
        return {'createdAt': SortOrder.desc};
      case 'Theo dõi nhiều nhất':
        return {'followedCount': SortOrder.desc};
      case 'Mới cập nhật':
      default:
        return {'latestUploadedChapter': SortOrder.desc};
    }
  }

  /// Thực thi tìm kiếm và điều hướng sang màn kết quả.
  Future<void> performSearch() async {
    isLoading = true;
    refreshUI();

    final SortManga sortManga = SortManga(
      title: searchController.text.trim().isNotEmpty
          ? searchController.text.trim()
          : null,
      includedTags: selectedTags.isNotEmpty ? selectedTags.toList() : null,
      excludedTags: excludedTags.isNotEmpty ? excludedTags.toList() : null,
      contentRating:
          safetyFilter != 'Tất cả' ? <String>[safetyFilter.toLowerCase()] : null,
      status: statusFilter != 'Tất cả'
          ? <String>[statusFilter.toLowerCase()]
          : null,
      publicationDemographic: demographicFilter != 'Tất cả'
          ? <String>[demographicFilter.toLowerCase()]
          : null,
      order: _getSortOrder(),
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
