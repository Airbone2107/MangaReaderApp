import 'package:flutter/material.dart';
import 'package:manga_reader_app/data/models/sort_manga_model.dart';
import '../../../data/models/manga/tag.dart';
import '../logic/search_logic.dart';

/// Màn hình tìm kiếm nâng cao cho manga.
class AdvancedSearchScreen extends StatefulWidget {
  final SortManga? initialSortManga;
  const AdvancedSearchScreen({super.key, this.initialSortManga});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final SearchLogic _logic = SearchLogic();

  @override
  void initState() {
    super.initState();
    _logic.init(
      context,
      () {
        if (mounted) {
          setState(() {});
        }
      },
      initialSortManga: widget.initialSortManga,
    );
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm Truyện Nâng Cao')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _logic.searchController,
              decoration: const InputDecoration(
                labelText: 'Tên truyện',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ExpansionTile(title: const Text('Tags'), children: _buildTagsList()),
          _buildComboBox(
            label: 'Độ an toàn',
            items: const <String>[
              'Tất cả',
              'Safe',
              'Suggestive',
              'Erotica',
              'Pornographic',
            ],
            value: _logic.safetyFilter,
            onChanged: (String? value) =>
                setState(() => _logic.safetyFilter = value!),
          ),
          _buildComboBox(
            label: 'Tình trạng',
            items: const <String>[
              'Tất cả',
              'Ongoing',
              'Completed',
              'Hiatus',
              'Cancelled',
            ],
            value: _logic.statusFilter,
            onChanged: (String? value) =>
                setState(() => _logic.statusFilter = value!),
          ),
          _buildComboBox(
            label: 'Dành cho',
            items: const <String>[
              'Tất cả',
              'Shounen',
              'Shoujo',
              'Seinen',
              'Josei',
            ],
            value: _logic.demographicFilter,
            onChanged: (String? value) =>
                setState(() => _logic.demographicFilter = value!),
          ),
          _buildComboBox(
            label: 'Sắp xếp theo',
            items: const <String>[
              'Mới cập nhật',
              'Truyện mới',
              'Theo dõi nhiều nhất',
            ],
            value: _logic.sortBy,
            onChanged: (String? value) =>
                setState(() => _logic.sortBy = value!),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _logic.performSearch,
              child: _logic.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Tìm kiếm'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTagsList() {
    final Map<String, List<Tag>> groupedTags = <String, List<Tag>>{};
    for (final Tag tag in _logic.availableTags) {
      groupedTags.putIfAbsent(tag.attributes.group, () => <Tag>[]).add(tag);
    }

    return groupedTags.entries.map((MapEntry<String, List<Tag>> entry) {
      return ExpansionTile(
        title: Text(entry.key.toUpperCase()),
        children: entry.value.map((Tag tag) {
          final bool isIncluded = _logic.selectedTags.contains(tag.id);
          final bool isExcluded = _logic.excludedTags.contains(tag.id);
          return ListTile(
            title: Text(tag.attributes.name['en'] ?? 'Unknown Tag'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    isIncluded
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: Colors.green,
                  ),
                  onPressed: () => _logic.onTagIncludePressed(tag),
                ),
                IconButton(
                  icon: Icon(
                    isExcluded
                        ? Icons.indeterminate_check_box
                        : Icons.check_box_outline_blank,
                    color: Colors.red,
                  ),
                  onPressed: () => _logic.onTagExcludePressed(tag),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }).toList();
  }

  Widget _buildComboBox({
    required String label,
    required List<String> items,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map(
              (String item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
