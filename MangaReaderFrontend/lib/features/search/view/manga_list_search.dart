import '../../../data/models/sort_manga_model.dart';
import 'package:flutter/material.dart';
import '../../../shared_widgets/manga_grid_view.dart';
import '../../../shared_widgets/scaffold_with_animated_app_bar.dart';

/// Màn hình hiển thị kết quả tìm kiếm theo tiêu chí đã chọn.
class MangaListSearch extends StatefulWidget {
  final SortManga sortManga;

  const MangaListSearch({super.key, required this.sortManga});

  @override
  State<MangaListSearch> createState() => _MangaListSearchState();
}

class _MangaListSearchState extends State<MangaListSearch> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAnimatedAppBar(
      title: 'Kết Quả Tìm Kiếm',
      actions: <Widget>[
        IconButton(
          icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
        ),
      ],
      bodyBuilder: (ScrollController controller) => MangaGridView(
        sortManga: widget.sortManga,
        controller: controller,
        isGridView: _isGridView,
      ),
    );
  }
}
