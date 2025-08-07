import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_reader_app/data/models/manga/relationship.dart';

void main() {
  group('Relationship Model Test', () {
    // 1. Dữ liệu JSON mẫu
    const String relationshipJson = '''
    {
      "id": "f5d2f626-444f-4a72-887c-4bf1757e283b",
      "type": "author",
      "attributes": {
        "name": "Author Name"
      }
    }
    ''';

    final relationshipMap =
        json.decode(relationshipJson) as Map<String, dynamic>;

    // 2. Test phương thức fromJson
    test('fromJson should correctly parse the JSON', () {
      // Arrange & Act
      final relationship = Relationship.fromJson(relationshipMap);

      // Assert
      expect(relationship.id, 'f5d2f626-444f-4a72-887c-4bf1757e283b');
      expect(relationship.type, 'author');
      expect(relationship.attributes, isA<Map<String, dynamic>>());
      expect(relationship.attributes!['name'], 'Author Name');
    });

    // 3. Test phương thức toJson
    test('toJson should correctly convert the object to JSON', () {
      // Arrange
      final relationship = Relationship.fromJson(relationshipMap);

      // Act
      final resultJson = relationship.toJson();

      // Assert
      expect(resultJson, relationshipMap);
    });

    // 4. Test trường hợp attributes là null
    test('fromJson should handle null attributes', () {
      // Arrange
      final relationshipMapWithoutAttributes = <String, dynamic>{
        'id': 'f5d2f626-444f-4a72-887c-4bf1757e283b',
        'type': 'author',
        'attributes': null,
      };

      // Act
      final relationship = Relationship.fromJson(
        relationshipMapWithoutAttributes,
      );

      // Assert
      expect(relationship.id, 'f5d2f626-444f-4a72-887c-4bf1757e283b');
      expect(relationship.type, 'author');
      expect(relationship.attributes, isNull);
    });
  });
}
