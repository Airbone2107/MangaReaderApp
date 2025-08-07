Chắc chắn rồi! Dưới đây là tệp `TODO.md` hướng dẫn chi tiết từng bước để tạo Unit Test cho các Model của bạn.

<!-- TODO.md -->
```markdown
# Hướng dẫn tạo Unit Test cho các Model Manga

Tài liệu này hướng dẫn chi tiết cách viết unit test cho các model trong thư mục `lib/data/models/manga` để đảm bảo chúng hoạt động chính xác với việc chuyển đổi JSON (serialization/deserialization) bằng cách sử dụng `freezed` và `json_serializable`.

## Mục lục
1.  [Giới thiệu về Unit Testing](#1-giới-thiệu-về-unit-testing)
2.  [Cài đặt môi trường Test](#2-cài-đặt-môi-trường-test)
3.  [Tạo file Test cho từng Model](#3-tạo-file-test-cho-từng-model)
    *   [3.1. Test cho `relationship.dart`](#31-test-cho-relationshipdart)
    *   [3.2. Test cho `tag.dart`](#32-test-cho-tagdart)
    *   [3.3. Test cho `cover.dart`](#33-test-cho-coverdart)
    *   [3.4. Test cho `manga_attributes.dart`](#34-test-cho-manga_attributesdart)
    *   [3.5. Test cho `manga.dart`](#35-test-cho-mangadart)
    *   [3.6. Test cho `list_response.dart`](#36-test-cho-list_responsedart)
4.  [Chạy tất cả các Test](#4-chạy-tất-cả-các-test)
5.  [Tổng kết](#5-tổng-kết)

---

## 1. Giới thiệu về Unit Testing

**Unit Testing** là một phương pháp kiểm thử phần mềm mà trong đó các "đơn vị" (unit) riêng lẻ của mã nguồn—thường là các hàm, phương thức, hoặc lớp—được kiểm tra độc lập để xác định xem chúng có hoạt động đúng như mong đợi hay không.

Đối với các model dữ liệu, unit test đặc biệt quan trọng để:
*   **Xác thực việc phân tích cú pháp JSON (Parsing)**: Đảm bảo rằng model có thể được tạo chính xác từ một chuỗi JSON nhận được từ API.
*   **Đảm bảo tính đúng đắn của việc tuần tự hóa (Serialization)**: Kiểm tra xem model có thể được chuyển đổi thành JSON một cách chính xác để gửi đi hay không.
*   **Phát hiện lỗi sớm**: Khi cấu trúc API thay đổi, các unit test sẽ nhanh chóng báo lỗi, giúp bạn cập nhật model kịp thời.

## 2. Cài đặt môi trường Test

Dự án của bạn đã có sẵn các dependency cần thiết trong `pubspec.yaml`. Thư mục `test` là nơi chứa tất cả các file test của dự án. Cấu trúc thư mục trong `test` nên phản ánh cấu trúc của `lib` để dễ dàng quản lý.

Ví dụ, để test các model trong `lib/data/models/manga/`, chúng ta sẽ tạo các file test trong `test/data/models/manga/`.

## 3. Tạo file Test cho từng Model

Chúng ta sẽ tạo một file test riêng cho mỗi model. Mỗi file test sẽ chứa các trường hợp kiểm thử cho phương thức `fromJson` và `toJson`.

### 3.1. Test cho `relationship.dart`

Tạo file mới tại đường dẫn: `MangaReaderFrontend\test\data\models\manga\relationship_test.dart`

<!-- MangaReaderFrontend\test\data\models\manga\relationship_test.dart -->
```dart
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

    final relationshipMap = json.decode(relationshipJson) as Map<String, dynamic>;

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
        'attributes': null
      };

      // Act
      final relationship =
          Relationship.fromJson(relationshipMapWithoutAttributes);

      // Assert
      expect(relationship.id, 'f5d2f626-444f-4a72-887c-4bf1757e283b');
      expect(relationship.type, 'author');
      expect(relationship.attributes, isNull);
    });
  });
}
```

### 3.2. Test cho `tag.dart`

Tạo file mới tại đường dẫn: `MangaReaderFrontend\test\data\models\manga\tag_test.dart`

<!-- MangaReaderFrontend\test\data\models\manga\tag_test.dart -->
```dart
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
      final attributes =
          TagAttributes.fromJson(tagMap['attributes'] as Map<String, dynamic>);

      expect(attributes.name['en'], 'Action');
      expect(attributes.description['en'], 'Description for Action');
      expect(attributes.group, 'genre');
      expect(attributes.version, 1);
    });

    test('TagAttributes.toJson should correctly convert the object to JSON',
        () {
      final attributes =
          TagAttributes.fromJson(tagMap['attributes'] as Map<String, dynamic>);
      final resultJson = attributes.toJson();
      expect(resultJson, tagMap['attributes']);
    });
  });
}
```

### 3.3. Test cho `cover.dart`

Tạo file mới tại đường dẫn: `MangaReaderFrontend\test\data\models\manga\cover_test.dart`

<!-- MangaReaderFrontend\test\data\models\manga\cover_test.dart -->
```dart
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
          coverMap['attributes'] as Map<String, dynamic>);

      expect(attributes.fileName, 'cover.jpg');
      expect(attributes.description, 'Main cover');
      expect(attributes.volume, '1');
      expect(attributes.locale, 'en');
      expect(attributes.version, 1);
      expect(attributes.createdAt, DateTime.parse('2021-05-24T17:03:00.000Z'));
      expect(attributes.updatedAt, DateTime.parse('2021-05-24T17:03:00.000Z'));
    });

    test('CoverAttributes.toJson should correctly convert the object to JSON',
        () {
      final attributes = CoverAttributes.fromJson(
          coverMap['attributes'] as Map<String, dynamic>);
      final resultJson = attributes.toJson();
      expect(resultJson, coverMap['attributes']);
    });
  });
}
```

### 3.4. Test cho `manga_attributes.dart`

Tạo file mới tại đường dẫn: `MangaReaderFrontend\test\data\models\manga\manga_attributes_test.dart`

<!-- MangaReaderFrontend\test\data\models\manga\manga_attributes_test.dart -->
```dart
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
      expect(attributes.availableTranslatedLanguages, containsAll(<String>['en', 'vi']));
      expect(attributes.latestUploadedChapter,
          'a1b2c3d4-e5f6-a7b8-c9d0-e1f2a3b4c5d6');
      expect(attributes.tags, isA<List<Tag>>());
      expect(attributes.tags.first.id, '423e2eae-a7a2-4a8b-ac03-a8351462d71d');
      expect(attributes.state, 'published');
      expect(attributes.version, 1);
      expect(attributes.createdAt, DateTime.parse('2020-01-01T00:00:00.000Z'));
      expect(attributes.updatedAt, DateTime.parse('2021-01-01T00:00:00.000Z'));
    });

    test('MangaAttributes.toJson should correctly convert the object to JSON',
        () {
      final attributes = MangaAttributes.fromJson(mangaAttributesMap);
      final resultJson = attributes.toJson();
      expect(resultJson, mangaAttributesMap);
    });
  });
}
```

### 3.5. Test cho `manga.dart`

Tạo file mới tại đường dẫn: `MangaReaderFrontend\test\data\models\manga\manga_test.dart`

<!-- MangaReaderFrontend\test\data\models\manga\manga_test.dart -->
```dart
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
```

### 3.6. Test cho `list_response.dart`

Đây là một lớp generic, vì vậy chúng ta sẽ test nó với một kiểu cụ thể, ví dụ `Manga`.

Tạo file mới tại đường dẫn: `MangaReaderFrontend\test\data\models\manga\list_response_test.dart`

<!-- MangaReaderFrontend\test\data\models\manga\list_response_test.dart -->
```dart
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
      final response =
          ListResponse<Manga>.fromJson(mangaListResponseMap, Manga.fromJson);

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

    test('ListResponse<Manga>.toJson should correctly convert the object to JSON', () {
      final response = ListResponse<Manga>.fromJson(mangaListResponseMap, Manga.fromJson);
      final resultJson = response.toJson((manga) => manga.toJson());
      
      expect(resultJson, mangaListResponseMap);
    });
  });
}
```

## 4. Chạy tất cả các Test

Sau khi đã tạo tất cả các file test, bạn có thể chạy chúng từ cửa sổ Terminal trong Visual Studio Code hoặc terminal của hệ thống.

Mở terminal và di chuyển đến thư mục gốc của dự án (`MangaReaderFrontend`), sau đó chạy lệnh sau:

```bash
flutter test
```

Lệnh này sẽ tự động tìm và chạy tất cả các file có đuôi `_test.dart` trong thư mục `test`. Nếu tất cả các test đều thành công, bạn sẽ thấy output tương tự như sau:

```
00:02 +6: All tests passed!
```

Nếu có lỗi, terminal sẽ chỉ rõ test nào đã thất bại và lý do tại sao, giúp bạn dễ dàng sửa lỗi.

## 5. Tổng kết

Bằng cách thực hiện các bước trên, bạn đã xây dựng một bộ unit test vững chắc cho các model dữ liệu của mình. Điều này không chỉ đảm bảo code của bạn hoạt động đúng ở hiện tại mà còn giúp việc bảo trì và mở rộng ứng dụng trong tương lai trở nên dễ dàng và an toàn hơn.
```