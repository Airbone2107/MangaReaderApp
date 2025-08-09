import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_reader_app/data/models/user_model.dart';

void main() {
  group('User and ReadingProgress Model Test', () {
    const String userJsonString = '''
    {
      "_id": "60d0fe4f5311236168a109ca",
      "googleId": "123456789012345678901",
      "email": "test@example.com",
      "displayName": "Test User",
      "photoURL": "https://example.com/photo.jpg",
      "followingManga": ["manga-id-1", "manga-id-2"],
      "readingManga": [
        {
          "_id": "60d0fe4f5311236168a109cb",
          "mangaId": "manga-reading-1",
          "lastChapter": "chapter-10",
          "lastReadAt": "2023-01-01T12:00:00.000Z"
        }
      ],
      "createdAt": "2022-01-01T12:00:00.000Z"
    }
    ''';
    final userMap = json.decode(userJsonString) as Map<String, dynamic>;

    test('User.fromJson should correctly parse JSON from backend', () {
      final user = User.fromJson(userMap);

      expect(user.id, "60d0fe4f5311236168a109ca");
      expect(user.googleId, "123456789012345678901");
      expect(user.email, "test@example.com");
      expect(user.displayName, "Test User");
      expect(user.photoURL, "https://example.com/photo.jpg");
      expect(user.following, ["manga-id-1", "manga-id-2"]);
      expect(user.readingProgress.length, 1);
      expect(user.createdAt, DateTime.parse("2022-01-01T12:00:00.000Z"));

      final readingProgress = user.readingProgress.first;
      expect(readingProgress.id, "60d0fe4f5311236168a109cb");
      expect(readingProgress.mangaId, "manga-reading-1");
      expect(readingProgress.lastChapter, "chapter-10");
      expect(
          readingProgress.lastReadAt, DateTime.parse("2023-01-01T12:00:00.000Z"));
    });

    test('User.toJson should correctly convert the object to JSON for backend',
            () {
          final user = User.fromJson(userMap);
          final generatedJson = user.toJson();

          // So sánh trực tiếp với map ban đầu
          expect(generatedJson, userMap);
        });

    test('ReadingProgress.fromJson should handle missing optional _id', () {
      final readingProgressMap = {
        "mangaId": "manga-reading-2",
        "lastChapter": "chapter-11",
        "lastReadAt": "2023-02-01T12:00:00.000Z"
      };
      final readingProgress = ReadingProgress.fromJson(readingProgressMap);

      expect(readingProgress.id, isNull);
      expect(readingProgress.mangaId, "manga-reading-2");
    });
  });
}