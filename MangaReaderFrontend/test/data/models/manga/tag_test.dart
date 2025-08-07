import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_reader_app/data/models/manga/tag.dart';

void main() {
  group('Tag Model Test', () {
    const String tagJson = '''
    {
      "id": "423e2eae-a7a2-4a8b-ac03-a8351462d71d",
      "type": "tag",
      "attributes": {
        "name": {
          "en": "Action"
        },
        "description": {
          "en": "Description for Action"
        },
        "group": "genre",
        "version": 1
      }
    }
    ''';

    final tagMap = json.decode(tagJson) as Map<String, dynamic>;

    test('Tag.fromJson should correctly parse the JSON', () {
      final tag = Tag.fromJson(tagMap);

      expect(tag.id, '423e2eae-a7a2-4a8b-ac03-a8351462d71d');
      expect(tag.type, 'tag');
      expect(tag.attributes, isA<TagAttributes>());
    });

    test('Tag.toJson should correctly convert the object to JSON', () {
      final tag = Tag.fromJson(tagMap);
      final resultJson = tag.toJson();
      expect(resultJson, tagMap);
    });

    test('TagAttributes.fromJson should correctly parse the JSON', () {
      final attributes = TagAttributes.fromJson(
        tagMap['attributes'] as Map<String, dynamic>,
      );

      expect(attributes.name['en'], 'Action');
      expect(attributes.description['en'], 'Description for Action');
      expect(attributes.group, 'genre');
      expect(attributes.version, 1);
    });

    test(
      'TagAttributes.toJson should correctly convert the object to JSON',
      () {
        final attributes = TagAttributes.fromJson(
          tagMap['attributes'] as Map<String, dynamic>,
        );
        final resultJson = attributes.toJson();
        expect(resultJson, tagMap['attributes']);
      },
    );
  });
}
