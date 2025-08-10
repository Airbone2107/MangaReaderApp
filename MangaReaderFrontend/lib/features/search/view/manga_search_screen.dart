import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:manga_reader_app/data/models/author.dart';
import 'package:manga_reader_app/data/models/manga/tag.dart';
import 'package:manga_reader_app/data/models/sort_manga_model.dart';
import 'package:manga_reader_app/data/services/mangadex_api_service.dart';
import 'package:manga_reader_app/features/search/view/manga_list_search.dart';
import 'package:collection/collection.dart';
import 'package:manga_reader_app/utils/logger.dart';

// Trạng thái lựa chọn cho mỗi tag
enum TagTriState { none, include, exclude }

class AdvancedSearchScreen extends StatefulWidget {
  final MangaSearchQuery? initialFilters;

  const AdvancedSearchScreen({super.key, this.initialFilters});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  late MangaSearchQuery _searchQuery;
  final _apiService = MangaDexApiService();

  List<Tag> _availableTags = [];
  bool _tagsLoading = true;

  // Controllers
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _authorController = TextEditingController();
  final _artistController = TextEditingController();

  // Selected items for display
  final List<Author> _selectedAuthors = [];
  final List<Author> _selectedArtists = [];

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.initialFilters?.copyWith() ?? MangaSearchQuery();
    // Loại bỏ giá trị 'pornographic' nếu có trong bộ lọc khởi tạo
    _searchQuery.contentRating = _searchQuery.contentRating
        ?.where((e) => e != 'pornographic')
        .toList();
    _initializeFields();
    _loadTags();
  }

  void _initializeFields() {
    _titleController.text = _searchQuery.title ?? '';
    _yearController.text = _searchQuery.year?.toString() ?? '';
  }

  Future<void> _loadTags() async {
    try {
      final tags = await _apiService.fetchTags();
      if (mounted) {
        setState(() {
          _availableTags = tags;
          _tagsLoading = false;
        });
      }
    } catch (e, s) {
      logger.e("Failed to load tags", error: e, stackTrace: s);
      if (mounted) {
        setState(() => _tagsLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tải danh sách thể loại.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _authorController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  void _performSearch() {
    // Update query object from controllers before navigating
    _searchQuery.title = _titleController.text.trim();
    _searchQuery.year = int.tryParse(_yearController.text.trim());
    _searchQuery.authors = _selectedAuthors.map((a) => a.id).toList();
    _searchQuery.artists = _selectedArtists.map((a) => a.id).toList();
    // Đảm bảo không gửi 'pornographic' lên API
    _searchQuery.contentRating = (_searchQuery.contentRating ?? const <String>[])
        .where((e) => e != 'pornographic')
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MangaListSearch(
          sortManga: _searchQuery,
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _searchQuery = MangaSearchQuery();
      _selectedAuthors.clear();
      _selectedArtists.clear();
      _initializeFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm Kiếm Nâng Cao'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Đặt lại bộ lọc',
            onPressed: _resetFilters,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTextField(_titleController, 'Tên truyện'),
          _buildAuthorSearchField(
            'Tác giả',
            _authorController,
            _selectedAuthors,
            (author) => setState(() => _selectedAuthors.add(author)),
          ),
          _buildSelectedItemsChips(_selectedAuthors,
              (author) => setState(() => _selectedAuthors.remove(author))),
          _buildAuthorSearchField(
            'Họa sĩ',
            _artistController,
            _selectedArtists,
            (artist) => setState(() => _selectedArtists.add(artist)),
          ),
          _buildSelectedItemsChips(_selectedArtists,
              (artist) => setState(() => _selectedArtists.remove(artist))),
          _buildTextField(
            _yearController,
            'Năm phát hành',
            keyboardType: TextInputType.number,
          ),
          _buildSortOrderDropDown(),
          _buildMultiSelectChipGroup(
            'Trạng thái',
            ['ongoing', 'completed', 'hiatus', 'cancelled'],
            _searchQuery.status ?? [],
            (selected, value) {
              setState(() {
                final currentStatus = _searchQuery.status?.toList() ?? [];
                if (selected) {
                  currentStatus.add(value);
                } else {
                  currentStatus.remove(value);
                }
                _searchQuery.status = currentStatus;
              });
            },
            displayText: _statusLabelVi,
          ),
          _buildMultiSelectChipGroup(
            'Đối tượng',
            ['shounen', 'shoujo', 'josei', 'seinen', 'none'],
            _searchQuery.publicationDemographic ?? [],
            (selected, value) {
              setState(() {
                final currentDemo =
                    _searchQuery.publicationDemographic?.toList() ?? [];
                if (selected) {
                  currentDemo.add(value);
                } else {
                  currentDemo.remove(value);
                }
                _searchQuery.publicationDemographic = currentDemo;
              });
            },
          ),
          _buildMultiSelectChipGroup(
            'Mức độ nội dung',
            ['safe', 'suggestive', 'erotica'],
            _searchQuery.contentRating ?? [],
            (selected, value) {
              setState(() {
                final currentRating = _searchQuery.contentRating?.toList() ?? [];
                if (selected) {
                  currentRating.add(value);
                } else {
                  currentRating.remove(value);
                }
                _searchQuery.contentRating = currentRating;
              });
            },
            displayText: _contentRatingLabelVi,
          ),
          _buildTagsSection(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.search),
          label: const Text('Áp Dụng Bộ Lọc'),
          onPressed: _performSearch,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildAuthorSearchField(
      String label,
      TextEditingController controller,
      List<Author> selectedItems,
      Function(Author) onSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TypeAheadField<Author>(
        controller: controller,
        suggestionsCallback: (pattern) async {
          return await _apiService.searchAuthors(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(title: Text(suggestion.attributes.name));
        },
        onSelected: (suggestion) {
          if (!selectedItems.any((item) => item.id == suggestion.id)) {
            onSelected(suggestion);
          }
          controller.clear();
        },
        builder: (context, controller, focusNode) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: 'Tìm và thêm $label',
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.search),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedItemsChips(
      List<Author> items, Function(Author) onDeleted) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: items
            .map((item) => Chip(
                  label: Text(item.attributes.name),
                  onDeleted: () => onDeleted(item),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildMultiSelectChipGroup(
      String title,
      List<String> options,
      List<String> selectedValues,
      Function(bool, String) onSelected,
      {String Function(String option)? displayText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            return FilterChip(
              label: Text(
                displayText?.call(option) ??
                    (option.isNotEmpty
                        ? option[0].toUpperCase() + option.substring(1)
                        : option),
              ),
              selected: selectedValues.contains(option),
              showCheckmark: false,
              selectedColor: Colors.green.withOpacity(0.3),
              onSelected: (selected) => onSelected(selected, option),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Dịch nhãn hiển thị cho Trạng thái
  String _statusLabelVi(String option) {
    switch (option) {
      case 'ongoing':
        return 'Đang ra';
      case 'completed':
        return 'Hoàn thành';
      case 'hiatus':
        return 'Tạm dừng';
      case 'cancelled':
        return 'Bị hủy';
      default:
        return option;
    }
  }

  // Dịch nhãn hiển thị cho Mức độ nội dung
  String _contentRatingLabelVi(String option) {
    switch (option) {
      case 'safe':
        return 'An toàn';
      case 'suggestive':
        return 'Nhạy cảm';
      case 'erotica':
        return 'R16';
      default:
        return option;
    }
  }

  Widget _buildTagsSection() {
    final groupedTags =
        _availableTags.groupListsBy((tag) => tag.attributes.group);

    return ExpansionTile(
      title: const Text('Thể loại'),
      children: [
        if (_tagsLoading) const Center(child: CircularProgressIndicator()),
        // Hai chế độ bao gồm/loại trừ đặt gần nhau theo thứ tự hàng
        _buildTagModeSelector(
          'Chế độ bao gồm',
          _searchQuery.includedTagsMode ?? 'AND',
          (newMode) => setState(() => _searchQuery.includedTagsMode = newMode),
        ),
        _buildTagModeSelector(
          'Chế độ loại trừ',
          _searchQuery.excludedTagsMode ?? 'OR',
          (newMode) => setState(() => _searchQuery.excludedTagsMode = newMode),
        ),
        const SizedBox(height: 8),
        // Nhóm tag theo loại và hiển thị chip 3 trạng thái
        _buildTriStateTagGroups(groupedTags),
      ],
    );
  }

  Widget _buildTagModeSelector(
      String title, String currentMode, Function(String) onModeChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          ToggleButtons(
            isSelected: [currentMode == 'AND', currentMode == 'OR'],
            onPressed: (index) {
              onModeChanged(index == 0 ? 'AND' : 'OR');
            },
            borderRadius: BorderRadius.circular(8),
            children: const [
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('VÀ')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('HOẶC')),
            ],
          ),
        ],
      ),
    );
  }

  // Hiển thị danh sách tag được nhóm theo loại, mỗi tag có 3 trạng thái:
  // Include (xanh) -> Exclude (đỏ) -> None (bỏ chọn)
  Widget _buildTriStateTagGroups(Map<String, List<Tag>> groupedTags) {
    const List<String> groupOrder = ['genre', 'theme', 'format', 'content'];

    String groupTitle(String key) {
      switch (key) {
        case 'genre':
          return 'Thể loại';
        case 'theme':
          return 'Chủ đề';
        case 'format':
          return 'Định dạng';
        case 'content':
          return 'Nội dung';
        default:
          return key;
      }
    }

    String tagDisplayName(Tag tag) {
      return tag.attributes.name['vi'] ??
          tag.attributes.name['en'] ??
          tag.id;
    }

    final List<String> orderedKeys = groupedTags.keys.toList()
      ..sort((a, b) {
        int ia = groupOrder.indexOf(a);
        int ib = groupOrder.indexOf(b);
        ia = ia == -1 ? 999 : ia;
        ib = ib == -1 ? 999 : ib;
        if (ia != ib) return ia.compareTo(ib);
        return a.compareTo(b);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final key in orderedKeys) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
            child: Text(
              groupTitle(key),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 6.0,
            children: (groupedTags[key]!..sort(
              (a, b) => tagDisplayName(a).toLowerCase().compareTo(
                tagDisplayName(b).toLowerCase(),
              ),
            ))
                .map((tag) {
              final bool isIncluded =
                  (_searchQuery.includedTags ?? const <String>[])
                      .contains(tag.id);
              final bool isExcluded =
                  (_searchQuery.excludedTags ?? const <String>[])
                      .contains(tag.id);
              final TagTriState currentState = isIncluded
                  ? TagTriState.include
                  : (isExcluded ? TagTriState.exclude : TagTriState.none);

              Color selectedColor;
              switch (currentState) {
                case TagTriState.include:
                  selectedColor = Colors.green.withOpacity(0.3);
                  break;
                case TagTriState.exclude:
                  selectedColor = Colors.red.withOpacity(0.3);
                  break;
                case TagTriState.none:
                  selectedColor = Theme.of(context)
                      .chipTheme
                      .selectedColor ??
                      Colors.blueGrey.withOpacity(0.2);
                  break;
              }

              return FilterChip(
                label: Text(tagDisplayName(tag)),
                selected: currentState != TagTriState.none,
                selectedColor: selectedColor,
                showCheckmark: false,
                onSelected: (_) {
                  setState(() {
                    final List<String> included =
                        _searchQuery.includedTags?.toList() ?? <String>[];
                    final List<String> excluded =
                        _searchQuery.excludedTags?.toList() ?? <String>[];

                    if (currentState == TagTriState.include) {
                      // Include -> Exclude
                      included.remove(tag.id);
                      if (!excluded.contains(tag.id)) {
                        excluded.add(tag.id);
                      }
                    } else if (currentState == TagTriState.exclude) {
                      // Exclude -> None
                      excluded.remove(tag.id);
                    } else {
                      // None -> Include
                      if (!included.contains(tag.id)) {
                        included.add(tag.id);
                      }
                      excluded.remove(tag.id);
                    }

                    _searchQuery.includedTags = included;
                    _searchQuery.excludedTags = excluded;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
  
  Widget _buildSortOrderDropDown() {
    final Map<String, Map<String, SortOrder>> sortOptions = {
      'Phù hợp nhất': {'relevance': SortOrder.desc},
      'Mới cập nhật': {'latestUploadedChapter': SortOrder.desc},
      'Theo dõi nhiều nhất': {'followedCount': SortOrder.desc},
      'Truyện mới': {'createdAt': SortOrder.desc},
      'Điểm cao nhất': {'rating': SortOrder.desc},
      'Tiêu đề (A-Z)': {'title': SortOrder.asc},
      'Tiêu đề (Z-A)': {'title': SortOrder.desc},
    };

    String currentSelection = sortOptions.entries.firstWhere(
      (entry) =>
          const DeepCollectionEquality().equals(entry.value, _searchQuery.order),
      orElse: () => sortOptions.entries.first,
    ).key;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Sắp xếp theo',
          border: OutlineInputBorder(),
        ),
        value: currentSelection,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _searchQuery.order = sortOptions[newValue];
            });
          }
        },
        items: sortOptions.keys.map((String key) {
          return DropdownMenuItem<String>(
            value: key,
            child: Text(key),
          );
        }).toList(),
      ),
    );
  }
}
