import 'package:flutter_test/flutter_test.dart';
import 'package:manga_reader_app/data/models/sort_manga_model.dart';

void main() {
  group('SortManga toParams Test', () {
    test('toParams with no values should return an empty map', () {
      final sortManga = SortManga();
      expect(sortManga.toParams(), {});
    });

    test('toParams should correctly format all possible parameters', () {
      final sortManga = SortManga(
        title: 'Test Manga',
        authorOrArtist: 'author-or-artist-id',
        authors: ['author-id-1'],
        artists: ['artist-id-1', 'artist-id-2'],
        year: 2022,
        includedTags: ['tag-id-1', 'tag-id-2'],
        includedTagsMode: 'AND',
        excludedTags: ['tag-id-3'],
        excludedTagsMode: 'OR',
        status: ['ongoing', 'completed'],
        originalLanguage: ['ja'],
        excludedOriginalLanguage: ['ko'],
        availableTranslatedLanguage: ['en', 'vi'],
        publicationDemographic: ['shounen'],
        ids: ['manga-id-1', 'manga-id-2'],
        contentRating: ['safe', 'suggestive'],
        createdAtSince: '2022-01-01T00:00:00',
        updatedAtSince: '2023-01-01T00:00:00',
        hasAvailableChapters: true,
        group: 'group-id-1',
        order: {
          'latestUploadedChapter': SortOrder.desc,
          'relevance': SortOrder.asc,
          'rating': SortOrder.desc,
        },
      );

      final params = sortManga.toParams();

      expect(params['title'], 'Test Manga');
      expect(params['authorOrArtist'], 'author-or-artist-id');
      expect(params['authors[]'], ['author-id-1']);
      expect(params['artists[]'], ['artist-id-1', 'artist-id-2']);
      expect(params['year'], '2022');
      expect(params['includedTags[]'], ['tag-id-1', 'tag-id-2']);
      expect(params['includedTagsMode'], 'AND');
      expect(params['excludedTags[]'], ['tag-id-3']);
      expect(params['excludedTagsMode'], 'OR');
      expect(params['status[]'], ['ongoing', 'completed']);
      expect(params['originalLanguage[]'], ['ja']);
      expect(params['excludedOriginalLanguage[]'], ['ko']);
      expect(params['availableTranslatedLanguage[]'], ['en', 'vi']);
      expect(params['publicationDemographic[]'], ['shounen']);
      expect(params['ids[]'], ['manga-id-1', 'manga-id-2']);
      expect(params['contentRating[]'], ['safe', 'suggestive']);
      expect(params['createdAtSince'], '2022-01-01T00:00:00');
      expect(params['updatedAtSince'], '2023-01-01T00:00:00');
      expect(params['hasAvailableChapters'], '1');
      expect(params['group'], 'group-id-1');
      expect(params['order[latestUploadedChapter]'], 'desc');
      expect(params['order[relevance]'], 'asc');
      expect(params['order[rating]'], 'desc');
    });

    test('toParams should handle single list values correctly', () {
      final sortManga = SortManga(status: ['ongoing']);
      final params = sortManga.toParams();
      expect(params['status[]'], ['ongoing']);
    });

    test(
        'toParams should not include null or empty fields except for title and group',
            () {
          final sortManga = SortManga(
            title: '',
            authors: [],
            year: null,
            status: [],
          );
          final params = sortManga.toParams();
          expect(params.containsKey('title'), false);
          expect(params.containsKey('authors[]'), false);
          expect(params.containsKey('year'), false);
          expect(params.containsKey('status[]'), false);
        });

    test('toParams should handle order parameter correctly', () {
      final sortManga = SortManga(
        order: {'title': SortOrder.asc, 'year': SortOrder.desc},
      );
      final params = sortManga.toParams();
      expect(params['order[title]'], 'asc');
      expect(params['order[year]'], 'desc');
    });

    test('toParams should handle hasAvailableChapters correctly', () {
      var sortManga = SortManga(hasAvailableChapters: true);
      var params = sortManga.toParams();
      expect(params['hasAvailableChapters'], '1');

      sortManga = SortManga(hasAvailableChapters: false);
      params = sortManga.toParams();
      expect(params['hasAvailableChapters'], '0');
    });
  });
}