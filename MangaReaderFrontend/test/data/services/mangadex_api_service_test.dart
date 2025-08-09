import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/data/models/manga/tag.dart';
import 'package:manga_reader_app/data/services/mangadex_api_service.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.mocks.dart';
import 'api_test_data.dart'; // File này chứa dữ liệu JSON mẫu

void main() {
  late MockClient mockClient;
  late MangaDexApiService apiService;

  setUp(() {
    mockClient = MockClient();
    // Tiêm MockClient vào service, giúp ta kiểm soát hoàn toàn các lời gọi HTTP
    apiService = MangaDexApiService(client: mockClient);
  });

  group('MangaDexApiService Tests', () {
    group('fetchManga', () {
      test('trả về danh sách manga khi API gọi thành công (200)', () async {
        // Arrange: Giả lập client trả về mã 200 và dữ liệu manga
        when(mockClient.get(any)).thenAnswer(
              (_) async => http.Response(json.encode(mangaListResponse), 200),
        );

        // Act: Gọi phương thức cần test
        final result = await apiService.fetchManga();

        // Assert: Kiểm tra kết quả
        expect(result, isA<List<Manga>>());
        expect(result.length, 1);
        expect(result.first.attributes.title['en'], 'Test Manga');
      });

      test('ném ra Exception khi API trả về lỗi (ví dụ 404)', () async {
        // Arrange: Giả lập client trả về mã 404
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        // Act & Assert: Kiểm tra xem có ném ra Exception không
        final call = apiService.fetchManga();
        expect(call, throwsA(isA<Exception>()));
      });

      test(
        'ném ra Exception cụ thể khi API trả về lỗi 503 (bảo trì)',
            () async {
          // Arrange: Giả lập client trả về mã 503
          when(
            mockClient.get(any),
          ).thenAnswer((_) async => http.Response('Service Unavailable', 503));

          // Act & Assert: Kiểm tra Exception có chứa thông báo bảo trì
          final call = apiService.fetchManga();
          expect(
            call,
            throwsA(
              predicate(
                    (e) => e is Exception && e.toString().contains('bảo trì'),
              ),
            ),
          );
        },
      );
    });

    group('fetchMangaDetails', () {
      test('trả về chi tiết manga khi thành công', () async {
        // Arrange
        when(mockClient.get(any)).thenAnswer(
              (_) async => http.Response(json.encode(mangaDetailResponse), 200),
        );

        // Act
        final manga = await apiService.fetchMangaDetails('some-id');

        // Assert
        expect(manga, isA<Manga>());
        expect(manga.id, 'a1b2c3d4-e5f6-a7b8-c9d0-e1f2a3b4c5d6');
      });

      test('ném ra Exception khi thất bại', () async {
        // Arrange
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        // Act & Assert
        final call = apiService.fetchMangaDetails('some-id');
        expect(call, throwsA(isA<Exception>()));
      });
    });

    group('fetchChapters', () {
      test('trả về danh sách chapter và kết thúc vòng lặp khi thành công',
              () async {
            // SỬA LỖI: Sử dụng một when() duy nhất để xử lý tất cả các lời gọi đến endpoint feed
            when(mockClient.get(argThat(isA<Uri>().having(
                  (uri) => uri.path,
              'path',
              '/manga/some-manga-id/feed',
            )))).thenAnswer((realInvocation) async {
              final uri = realInvocation.positionalArguments.first as Uri;
              final offset = uri.queryParameters['offset'] ?? '0';

              // Trả về dữ liệu cho trang đầu tiên
              if (offset == '0') {
                return http.Response(json.encode(chapterListResponse), 200);
              }
              // Trả về danh sách rỗng cho các trang tiếp theo để dừng vòng lặp
              else {
                return http.Response(
                  json.encode({
                    "result": "ok",
                    "response": "collection",
                    "data": [],
                    "limit": 100,
                    "offset": int.parse(offset),
                    "total": 1
                  }),
                  200,
                );
              }
            });

            // Act
            final chapters = await apiService.fetchChapters('some-manga-id', 'en');

            // Assert
            expect(chapters, isA<List<dynamic>>());
            expect(chapters.length, 1);
            expect(chapters.first['id'], 'chapter-id-1');
          });

      test('ném ra Exception khi ngôn ngữ không hợp lệ', () {
        // Act & Assert
        expect(() => apiService.fetchChapters('some-id', ''), throwsException);
        expect(
              () => apiService.fetchChapters('some-id', 'invalid-lang'),
          throwsException,
        );
      });
    });

    group('fetchCoverUrl', () {
      test('trả về URL ảnh bìa hợp lệ khi thành công', () async {
        // Arrange
        when(mockClient.get(any)).thenAnswer(
              (_) async => http.Response(json.encode(coverArtResponse), 200),
        );

        // Act
        final url = await apiService.fetchCoverUrl('manga-id');

        // Assert
        expect(
          url,
          'https://uploads.mangadex.org/covers/manga-id/cover.jpg.512.jpg',
        );
      });

      test('ném ra Exception nếu không tìm thấy ảnh bìa', () async {
        // Arrange
        final emptyResponse = {
          'result': 'ok',
          'response': 'collection',
          'data': [],
          'limit': 1,
          'offset': 0,
          'total': 0,
        };
        when(mockClient.get(any)).thenAnswer(
              (_) async => http.Response(json.encode(emptyResponse), 200),
        );

        // Act & Assert
        final call = apiService.fetchCoverUrl('manga-id');
        expect(call, throwsA(isA<Exception>()));
      });
    });

    group('fetchChapterPages', () {
      test('trả về danh sách URL trang truyện khi thành công', () async {
        // Arrange
        when(mockClient.get(any)).thenAnswer(
              (_) async => http.Response(json.encode(atHomeServerResponse), 200),
        );

        // Act
        final pages = await apiService.fetchChapterPages('chapter-id');

        // Assert
        expect(pages, isA<List<String>>());
        expect(pages.length, 1);
        expect(pages.first, 'https://example.com/data/some-hash/page1.jpg');
      });
    });

    group('fetchTags', () {
      test('trả về danh sách tags khi thành công', () async {
        // Arrange
        when(mockClient.get(any)).thenAnswer(
              (_) async => http.Response(json.encode(tagListResponse), 200),
        );

        // Act
        final tags = await apiService.fetchTags();

        // Assert
        expect(tags, isA<List<Tag>>());
        expect(tags.length, 1);
        expect(tags.first.attributes.name['en'], 'Action');
      });
    });

    group('fetchMangaByIds', () {
      test('trả về danh sách manga khi fetch thành công', () async {
        // Arrange
        when(mockClient.get(any)).thenAnswer(
              (_) async => http.Response(json.encode(mangaListResponse), 200),
        );

        // Act
        final result = await apiService.fetchMangaByIds(['id1', 'id2']);

        // Assert
        expect(result, isA<List<Manga>>());
        expect(result.first.id, 'manga-id-1');
        verify(mockClient.get(any)).called(1);
      });

      test('trả về danh sách rỗng nếu mangaIds rỗng', () async {
        // Act
        final result = await apiService.fetchMangaByIds([]);

        // Assert
        expect(result, isA<List<Manga>>());
        expect(result.isEmpty, isTrue);
        // Đảm bảo không có lời gọi API nào được thực hiện
        verifyNever(mockClient.get(any));
      });

      test('ném ra Exception khi API thất bại', () async {
        // Arrange
        when(
          mockClient.get(any),
        ).thenAnswer((_) async => http.Response('Error', 500));

        // Act & Assert
        final call = apiService.fetchMangaByIds(['id1']);
        expect(call, throwsException);
      });
    });
  });
}