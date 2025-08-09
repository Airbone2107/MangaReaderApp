import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_reader_app/data/models/chapter_model.dart';

void main() {
  group('Chapter Model Test', () {
    final chapterMap = {
      'mangaId': 'manga-123',
      'chapterId': 'chapter-456',
      'chapterName': 'Chapter 1: The Beginning',
      'chapterList': [
        {'id': 'chapter-456', 'name': 'Chapter 1'},
        {'id': 'chapter-789', 'name': 'Chapter 2'}
      ],
    };

    final chapterJsonString = json.encode(chapterMap);

    test('Chapter.fromJson should correctly parse JSON', () {
      final chapter = Chapter.fromJson(json.decode(chapterJsonString));

      expect(chapter.mangaId, 'manga-123');
      expect(chapter.chapterId, 'chapter-456');
      expect(chapter.chapterName, 'Chapter 1: The Beginning');
      expect(chapter.chapterList, isA<List<dynamic>>());
      expect(chapter.chapterList.length, 2);
      expect((chapter.chapterList[0] as Map)['id'], 'chapter-456');
    });

    test('Chapter.toJson should correctly convert the object to JSON', () {
      final chapter = Chapter.fromJson(json.decode(chapterJsonString));
      final resultJson = chapter.toJson();

      expect(resultJson, chapterMap);
    });
  });
}