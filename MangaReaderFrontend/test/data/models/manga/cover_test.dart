import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_reader_app/data/models/manga/cover.dart';

void main() {
  group('Cover Model Test', () {
    const String coverJson = '''
    {
      "id": "a925433a-236b-4b13-a4a3-731338d3393e",
      "type": "cover_art",
      "attributes": {
        "fileName": "cover.jpg",
        "description": "Main cover",
        "volume": "1",
        "locale": "en",
        "version": 1,
        "createdAt": "2021-05-24T17:03:00.000Z",
        "updatedAt": "2021-05-24T17:03:00.000Z"
      }
    }
    ''';

    final coverMap = json.decode(coverJson) as Map<String, dynamic>;

    test('Cover.fromJson should correctly parse the JSON', () {
      final cover = Cover.fromJson(coverMap);

      expect(cover.id, 'a925433a-236b-4b13-a4a3-731338d3393e');
      expect(cover.type, 'cover_art');
      expect(cover.attributes, isA<CoverAttributes>());
    });

    test('Cover.toJson should correctly convert the object to JSON', () {
      final cover = Cover.fromJson(coverMap);
      final resultJson = cover.toJson();
      expect(resultJson, coverMap);
    });

    test('CoverAttributes.fromJson should correctly parse the JSON', () {
      final attributes = CoverAttributes.fromJson(
        coverMap['attributes'] as Map<String, dynamic>,
      );

      expect(attributes.fileName, 'cover.jpg');
      expect(attributes.description, 'Main cover');
      expect(attributes.volume, '1');
      expect(attributes.locale, 'en');
      expect(attributes.version, 1);
      expect(attributes.createdAt, DateTime.parse('2021-05-24T17:03:00.000Z'));
      expect(attributes.updatedAt, DateTime.parse('2021-05-24T17:03:00.000Z'));
    });

    test(
      'CoverAttributes.toJson should correctly convert the object to JSON',
      () {
        final attributes = CoverAttributes.fromJson(
          coverMap['attributes'] as Map<String, dynamic>,
        );
        final resultJson = attributes.toJson();
        expect(resultJson, coverMap['attributes']);
      },
    );
  });
}
