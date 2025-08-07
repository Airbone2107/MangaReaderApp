import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/data/models/manga/manga_attributes.dart';
import 'package:manga_reader_app/data/models/manga/relationship.dart';

void main() {
  group('Manga Model Test', () {
    const String mangaJson = '''
    {
      "id": "a1b2c3d4-e5f6-a7b8-c9d0-e1f2a3b4c5d6",
      "type": "manga",
      "attributes": {
        "title": { "en": "Test Manga" },
        "altTitles": [],
        "description": { "en": "Description" },
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
      "relationships": [
        {
          "id": "f5d2f626-444f-4a72-887c-4bf1757e283b",
          "type": "author"
        },
        {
          "id": "a925433a-236b-4b13-a4a3-731338d3393e",
          "type": "cover_art"
        }
      ]
    }
    ''';

    final mangaMap = json.decode(mangaJson) as Map<String, dynamic>;

    test('Manga.fromJson should correctly parse the JSON', () {
      final manga = Manga.fromJson(mangaMap);

      expect(manga.id, 'a1b2c3d4-e5f6-a7b8-c9d0-e1f2a3b4c5d6');
      expect(manga.type, 'manga');
      expect(manga.attributes, isA<MangaAttributes>());
      expect(manga.attributes.title['en'], 'Test Manga');
      expect(manga.relationships, isA<List<Relationship>>());
      expect(manga.relationships.length, 2);
      expect(manga.relationships[0].type, 'author');
      expect(manga.relationships[1].type, 'cover_art');
    });

    test('Manga.toJson should correctly convert the object to JSON', () {
      // Vì relationship trong json mẫu không có attributes, ta cần tạo 1 map tương ứng
      final expectedJson = json.decode(mangaJson) as Map<String, dynamic>;
      // `fromJson` của relationship sẽ thêm `attributes: null` nếu nó không có
      (expectedJson['relationships'] as List<dynamic>).forEach((element) {
        (element as Map<String, dynamic>)['attributes'] = null;
      });

      final manga = Manga.fromJson(mangaMap);
      final resultJson = manga.toJson();

      expect(resultJson, expectedJson);
    });
  });
}
