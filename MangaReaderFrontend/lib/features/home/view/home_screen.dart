import 'package:flutter/material.dart';
import 'package:manga_reader_app/config/language_config.dart';
import '../../../data/models/sort_manga_model.dart';
import '../../../shared_widgets/manga_grid_view.dart';
import '../../../shared_widgets/scaffold_with_animated_app_bar.dart';

/// Màn hình trang chủ hiển thị danh sách manga.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAnimatedAppBar(
      title: 'Manga Reader',
      actions: <Widget>[
        IconButton(
          icon: Icon(_isGridView ? Icons.grid_view : Icons.list),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
        ),
      ],
      bodyBuilder: (ScrollController controller) => MangaGridView(
        sortManga: SortManga(
          availableTranslatedLanguage: LanguageConfig.preferredLanguages,
        ),
        controller: controller,
        isGridView: _isGridView,
      ),
    );
  }
}
