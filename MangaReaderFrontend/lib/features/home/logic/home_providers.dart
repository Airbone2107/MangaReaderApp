import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/data/models/sort_manga_model.dart';
import 'package:manga_reader_app/data/services/mangadex_api_service.dart';

// Provider cho MangaDexApiService
final mangaDexApiServiceProvider = Provider((_) => MangaDexApiService());

// Provider cho top 10 theo dõi trong 1 ngày gần nhất
final topDailyFollowedMangaProvider = FutureProvider<List<Manga>>((ref) async {
  final api = ref.watch(mangaDexApiServiceProvider);
  final oneDayAgo = DateTime.now().subtract(const Duration(days: 1));
  final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(oneDayAgo);

  return api.fetchManga(
    limit: 10,
    includes: <String>['tag'],
    sortManga: SortManga(
      order: <String, SortOrder>{'followedCount': SortOrder.desc},
      updatedAtSince: formattedDate,
    ),
  );
});

// Provider cho top 10 tuần
final topWeeklyMangaProvider = FutureProvider<List<Manga>>((ref) async {
  final api = ref.watch(mangaDexApiServiceProvider);
  final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
  final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(sevenDaysAgo);

  return api.fetchManga(
    limit: 10,
    includes: <String>['tag'],
    sortManga: SortManga(
      order: <String, SortOrder>{'followedCount': SortOrder.desc},
      updatedAtSince: formattedDate,
    ),
  );
});

// Provider cho top 10 tháng
final topMonthlyMangaProvider = FutureProvider<List<Manga>>((ref) async {
  final api = ref.watch(mangaDexApiServiceProvider);
  final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
  final formattedDate =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(thirtyDaysAgo);

  return api.fetchManga(
    limit: 10,
    includes: <String>['tag'],
    sortManga: SortManga(
      order: <String, SortOrder>{'followedCount': SortOrder.desc},
      updatedAtSince: formattedDate,
    ),
  );
});

// Provider cho 10 truyện mới cập nhật
final recentlyUpdatedMangaProvider = FutureProvider<List<Manga>>((ref) async {
  final api = ref.watch(mangaDexApiServiceProvider);
  return api.fetchManga(
    limit: 10,
    includes: <String>['tag'],
    sortManga: SortManga(
      order: <String, SortOrder>{'latestUploadedChapter': SortOrder.desc},
    ),
  );
});

// Provider cho nội dung các tab
final tabContentProvider =
    FutureProvider.family<List<Manga>, SortManga>((ref, sortManga) async {
  final api = ref.watch(mangaDexApiServiceProvider);
  return api.fetchManga(
    limit: 21,
    sortManga: sortManga,
  );
});


