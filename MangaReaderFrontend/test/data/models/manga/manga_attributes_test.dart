import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_reader_app/data/models/manga/manga_attributes.dart';
import 'package:manga_reader_app/data/models/manga/tag.dart';

void main() {
  group('MangaAttributes Model Test', () {
    const String mangaAttributesJson = '''
    {
      "title": { "en": "Test Manga" },
      "altTitles": [ { "ja": "テスト漫画" } ],
      "description": { "en": "This is a test manga." },
      "isLocked": false,
      "links": { "al": "12345" },
      "originalLanguage": "ja",
      "lastVolume": "5",
      "lastChapter": "50",
      "publicationDemographic": "shounen",
      "status": "ongoing",
      "year": 2020,
      "contentRating": "safe",
      "chapterNumbersResetOnNewVolume": false,
      "availableTranslatedLanguages": ["en", "vi"],
      "latestUploadedChapter": "a1b2c3d4-e5f6-a7b8-c9d0-e1f2a3b4c5d6",
      "tags": [
        {
          "id": "423e2eae-a7a2-4a8b-ac03-a8351462d71d",
          "type": "tag",
          "attributes": {
            "name": { "en": "Action" },
            "description": {},
            "group": "genre",
            "version": 1
          }
        }
      ],
      "state": "published",
      "version": 1,
      "createdAt": "2020-01-01T00:00:00.000Z",
      "updatedAt": "2021-01-01T00:00:00.000Z"
    }
    ''';

    final mangaAttributesMap =
        json.decode(mangaAttributesJson) as Map<String, dynamic>;

    test('MangaAttributes.fromJson should correctly parse the JSON', () {
      final attributes = MangaAttributes.fromJson(mangaAttributesMap);

      expect(attributes.title['en'], 'Test Manga');
      expect(attributes.altTitles.first['ja'], 'テスト漫画');
      expect(attributes.description['en'], 'This is a test manga.');
      expect(attributes.isLocked, false);
      expect(attributes.links!['al'], '12345');
      expect(attributes.originalLanguage, 'ja');
      expect(attributes.lastVolume, '5');
      expect(attributes.lastChapter, '50');
      expect(attributes.publicationDemographic, 'shounen');
      expect(attributes.status, 'ongoing');
      expect(attributes.year, 2020);
      expect(attributes.contentRating, 'safe');
      expect(attributes.chapterNumbersResetOnNewVolume, false);
      expect(
        attributes.availableTranslatedLanguages,
        containsAll(<String>['en', 'vi']),
      );
      expect(
        attributes.latestUploadedChapter,
        'a1b2c3d4-e5f6-a7b8-c9d0-e1f2a3b4c5d6',
      );
      expect(attributes.tags, isA<List<Tag>>());
      expect(attributes.tags.first.id, '423e2eae-a7a2-4a8b-ac03-a8351462d71d');
      expect(attributes.state, 'published');
      expect(attributes.version, 1);
      expect(attributes.createdAt, DateTime.parse('2020-01-01T00:00:00.000Z'));
      expect(attributes.updatedAt, DateTime.parse('2021-01-01T00:00:00.000Z'));
    });

    test(
      'MangaAttributes.toJson should correctly convert the object to JSON',
      () {
        final attributes = MangaAttributes.fromJson(mangaAttributesMap);
        final resultJson = attributes.toJson();
        expect(resultJson, mangaAttributesMap);
      },
    );
  });
}
