import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:manga_reader_app/data/models/sort_manga_model.dart';
import 'package:manga_reader_app/features/home/widgets/tab_content_view.dart';
import 'package:manga_reader_app/features/home/widgets/top_followed_carousel.dart';
import 'package:manga_reader_app/features/search/view/manga_list_search.dart';

class DiscoverSection extends HookWidget {
  const DiscoverSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 5);
    final scrollController = useScrollController();
    final searchController = useTextEditingController();
    final searchKey = useMemoized(() => GlobalKey(), const []);
    final carouselKey = useMemoized(() => GlobalKey(), const []);

    final tabs = <String, MangaSearchQuery>{
      'Nổi Bật': MangaSearchQuery(
        contentRating: const <String>['safe', 'suggestive'],
        order: <String, SortOrder>{'followedCount': SortOrder.desc},
      ),
      'Manga': MangaSearchQuery(
        contentRating: const <String>['safe', 'suggestive'],
        originalLanguage: <String>['ja'],
        order: <String, SortOrder>{'rating': SortOrder.desc},
      ),
      'Manhwa': MangaSearchQuery(
        contentRating: const <String>['safe', 'suggestive'],
        originalLanguage: <String>['ko'],
        order: <String, SortOrder>{'rating': SortOrder.desc},
      ),
      'Manhua': MangaSearchQuery(
        contentRating: const <String>['safe', 'suggestive'],
        originalLanguage: <String>['zh'],
        order: <String, SortOrder>{'rating': SortOrder.desc},
      ),
      'Hoàn Thành': MangaSearchQuery(
        contentRating: const <String>['safe', 'suggestive'],
        status: <String>['completed'],
        order: <String, SortOrder>{'rating': SortOrder.desc},
      ),
    };

    double _heightOf(GlobalKey key) {
      final ctx = key.currentContext;
      if (ctx == null) return 0;
      final render = ctx.findRenderObject();
      if (render is RenderBox) {
        return render.size.height;
      }
      return 0;
    }

    void handleTabTap(int index) {
      if (!scrollController.hasClients) return;
      final double target = _heightOf(searchKey) + _heightOf(carouselKey);
      final double clamped = target.clamp(0.0, scrollController.position.maxScrollExtent);
      if (scrollController.offset < clamped - 4) {
        scrollController.animateTo(
          clamped,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }

    useEffect(() {
      void listener() {
        if (tabController.indexIsChanging) {
          handleTabTap(tabController.index);
        }
      }
      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    void triggerSearch() {
      final query = searchController.text.trim();
      if (query.isEmpty) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MangaListSearch(
            sortManga: MangaSearchQuery(
              title: query,
              contentRating: const <String>['safe', 'suggestive'],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // Thanh tìm kiếm theo tên
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  key: searchKey,
                  child: TextField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => triggerSearch(),
                  decoration: InputDecoration(
                    hintText: 'Tìm theo tên truyện...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: triggerSearch,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                ),
                ),
              ),
            ),
            // Tiêu đề nhỏ + Carousel top 10 theo dõi trong 1 ngày gần nhất
            SliverToBoxAdapter(
              child: Column(
                key: carouselKey,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: Builder(
                      builder: (context) {
                        final tabStyle = Theme.of(context)
                                .tabBarTheme
                                .labelStyle ??
                            const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
                        return Text(
                          'Truyện mới cập nhật',
                          style: tabStyle,
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: TopFollowedCarousel(),
                  ),
                ],
              ),
            ),
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                forceElevated: innerBoxIsScrolled,
                toolbarHeight: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      controller: tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      padding: const EdgeInsets.only(left: 16),
                      labelPadding: const EdgeInsets.only(left: 0, right: 16),
                      indicatorPadding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: tabs.keys
                          .map((String name) => Tab(text: name))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: AnimatedBuilder(
          animation: tabController,
          builder: (context, _) {
            final current = tabController.index;
            final values = tabs.values.toList(growable: false);
            return TabBarView(
              controller: tabController,
              children: List.generate(values.length, (i) {
                return TabContentView(
                  sortManga: values[i],
                  isActive: i == current,
                );
              }),
            );
          },
        ),
      ),
    );
  }
}


