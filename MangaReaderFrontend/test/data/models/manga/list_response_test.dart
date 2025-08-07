import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_reader_app/data/models/manga/list_response.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';

void main() {
  group('ListResponse<T> Model Test', () {
    const String mangaListResponseJson = '''
    {
      "result": "ok",
      "response": "collection",
      "data": [
        {
          "id": "manga-id-1",
          "type": "manga",
          "attributes": {
            "title": { "en": "Manga 1" },
            "altTitles": [],
            "description": { "en": "Desc 1" },
            "isLocked": false,
            "originalLanguage": "ja",
            "status": "ongoing",
            "contentRating": "safe",
            "chapterNumbersResetOnNewVolume": false,
            "tags": [],
            "state": "published",
            "version": 1,
            "createdAt": "2020-01-01T00:00:00.000Z",
            "updatedAt": "2021-01-01T00:00:00.000Z"
          },
          "relationships": []
        }
      ],
      "limit": 1,
      "offset": 0,
      "total": 100
    }
    ''';

    final mangaListResponseMap =
        json.decode(mangaListResponseJson) as Map<String, dynamic>;

    test('ListResponse<Manga>.fromJson should correctly parse the JSON', () {
      final response = ListResponse<Manga>.fromJson(
        mangaListResponseMap,
        (json) => Manga.fromJson(json as Map<String, dynamic>),
      );

      expect(response.result, 'ok');
      expect(response.response, 'collection');
      expect(response.limit, 1);
      expect(response.offset, 0);
      expect(response.total, 100);
      expect(response.data, isA<List<Manga>>());
      expect(response.data.length, 1);
      expect(response.data.first.id, 'manga-id-1');
      expect(response.data.first.attributes.title['en'], 'Manga 1');
    });

    test(
      'ListResponse<Manga>.toJson should correctly convert the object to JSON',
      () {
        final response = ListResponse<Manga>.fromJson(
          mangaListResponseMap,
          (json) => Manga.fromJson(json as Map<String, dynamic>),
        );
        final resultJson = response.toJson((manga) => manga.toJson());

        expect(resultJson, mangaListResponseMap);
      },
    );
  });
}
