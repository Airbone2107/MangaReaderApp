Chào bạn,

Tôi đã xem xét yêu cầu của bạn về việc cập nhật project để luôn bật tham số `hasAvailableChapters` trong các lệnh gọi API lấy danh sách manga. Hướng đi của bạn là rất chính xác khi không thay đổi file Model mà thay vào đó sẽ điều chỉnh trực tiếp các lời gọi API.

Cách làm này giúp giữ cho Model dữ liệu (`SortManga`) được trong sáng, không chứa các logic mặc định của ứng dụng, đồng thời đảm bảo mọi lệnh gọi API liên quan đều tuân thủ yêu cầu mới.

Để thực hiện việc này, chúng ta chỉ cần cập nhật file `MangaReaderFrontend/lib/data/services/mangadex_api_service.dart`, nơi chứa logic gọi API MangaDex. Tôi sẽ thêm tham số `hasAvailableChapters: '1'` vào các phương thức `fetchManga` và `fetchMangaByIds`.

Dưới đây là nội dung đầy đủ của file đã được cập nhật. Bạn chỉ cần sao chép và dán để thay thế file hiện tại.

### Hướng dẫn cập nhật

Bạn hãy mở file sau và thay thế toàn bộ nội dung của nó bằng đoạn code dưới đây.

```dart
// MangaReaderFrontend/lib/data/services/mangadex_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/logger.dart';
import '../models/manga/list_response.dart';
import '../models/manga/manga.dart';
import '../models/manga/tag.dart';
import '../models/sort_manga_model.dart';

/// Service gọi API MangaDex.
///
/// Cung cấp các phương thức lấy danh sách manga, chi tiết manga, danh sách chapter,
/// trang ảnh chapter, danh sách tags và lấy manga theo danh sách id.
class MangaDexApiService {
  final String baseUrl = 'https://api.mangadex.org';
  final http.Client _client;

  /// Khởi tạo service với khả năng truyền vào `http.Client` tùy biến.
  /// Nếu không truyền, sẽ tạo `http.Client` mặc định.
  MangaDexApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Ghi log lỗi với thông tin chi tiết phản hồi từ API.
  void logError(String functionName, http.Response response) {
    logger.e(
      'Lỗi trong hàm $functionName',
      error: 'Mã trạng thái: ${response.statusCode}',
      stackTrace: StackTrace.fromString('Nội dung phản hồi: ${response.body}'),
    );
  }

  /// Lấy danh sách manga theo điều kiện sắp xếp, phân trang.
  Future<List<Manga>> fetchManga({
    int? limit,
    int? offset,
    SortManga? sortManga,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'includes[]': 'cover_art',
      'hasAvailableChapters': '1', // Luôn bật mặc định
    };

    if (limit != null) {
      params['limit'] = limit.toString();
    }
    if (offset != null) {
      params['offset'] = offset.toString();
    }

    if (sortManga != null) {
      params.addAll(sortManga.toParams());
    }

    final Uri uri = Uri.parse(
      '$baseUrl/manga',
    ).replace(queryParameters: params);
    final http.Response response = await _client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final listResponse = ListResponse<Manga>.fromJson(
        data,
        (json) => Manga.fromJson(json as Map<String, dynamic>),
      );
      return listResponse.data;
    } else if (response.statusCode == 503) {
      throw Exception(
        'Máy chủ MangaDex hiện đang bảo trì, xin vui lòng thử lại sau!',
      );
    } else {
      logError('fetchManga', response);
      throw Exception('Lỗi khi tải manga: ${response.statusCode}');
    }
  }

  /// Lấy chi tiết một manga theo `mangaId`.
  Future<Manga> fetchMangaDetails(String mangaId) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'includes[]': ['author', 'cover_art']
    };
    final Uri uri = Uri.parse(
      '$baseUrl/manga/$mangaId',
    ).replace(queryParameters: params);
    final http.Response response = await _client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Manga.fromJson(data['data'] as Map<String, dynamic>);
    } else {
      logError('fetchMangaDetails', response);
      throw Exception('Lỗi khi tải chi tiết manga');
    }
  }

  /// Lấy danh sách các chapter của một manga theo ngôn ngữ, thứ tự, và giới hạn tối đa.
  Future<List<dynamic>> fetchChapters(
    String mangaId,
    List<String> languages, {
    String order = 'desc',
    int? maxChapters,
  }) async {
    final List<String> validLanguages = List<String>.from(languages);
    validLanguages.removeWhere(
      (String lang) => !RegExp(r'^[a-z]{2}(-[a-z]{2})?$').hasMatch(lang),
    );

    if (validLanguages.isEmpty) {
      throw Exception(
        'Danh sách ngôn ngữ không hợp lệ. Vui lòng kiểm tra cài đặt.',
      );
    }

    final List<dynamic> allChapters = <dynamic>[];
    int offset = 0;
    const int limit = 100;

    while (true) {
      final Map<String, dynamic> queryParameters = <String, dynamic>{
        'limit': limit.toString(),
        'offset': offset.toString(),
        'order[chapter]': order,
        'translatedLanguage[]': validLanguages,
      };

      final Uri uri = Uri.parse('$baseUrl/manga/$mangaId/feed')
          .replace(queryParameters: queryParameters);
      final http.Response response = await _client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> chapters = data['data'] as List<dynamic>;

        if (chapters.isEmpty) {
          break;
        }

        allChapters.addAll(chapters);

        if (maxChapters != null && allChapters.length >= maxChapters) {
          return allChapters.take(maxChapters).toList();
        }

        offset += limit;
      } else if (response.statusCode == 503) {
        throw Exception(
          'Máy chủ MangaDex hiện đang bảo trì, xin vui lòng thử lại sau!',
        );
      } else {
        logError('fetchChapters', response);
        throw Exception(
          'Lỗi trong hàm fetchChapters:\nMã trạng thái: ${response.statusCode}\nNội dung phản hồi: ${response.body}',
        );
      }
    }

    return allChapters;
  }

  /// Lấy danh sách URL trang ảnh của một chapter.
  Future<List<String>> fetchChapterPages(String chapterId) async {
    final http.Response response = await _client.get(
      Uri.parse('$baseUrl/at-home/server/$chapterId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<String> pages = List<String>.from(
        data['chapter']['data'] as List<dynamic>,
      );
      final String imageBaseUrl = data['baseUrl'] as String;
      final String hash = data['chapter']['hash'] as String;
      return pages
          .map((String page) => '$imageBaseUrl/data/$hash/$page')
          .toList();
    } else {
      logError('fetchChapterPages', response);
      throw Exception('Lỗi khi tải các trang chương');
    }
  }

  /// Lấy toàn bộ danh sách tags của MangaDex.
  Future<List<Tag>> fetchTags() async {
    final http.Response response = await _client.get(
      Uri.parse('$baseUrl/manga/tag'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final listResponse = ListResponse<Tag>.fromJson(
        data,
        (json) => Tag.fromJson(json as Map<String, dynamic>),
      );
      return listResponse.data;
    } else {
      logError('fetchTags', response);
      throw Exception('Lỗi khi tải danh sách tags');
    }
  }

  /// Lấy thông tin nhiều manga theo danh sách `mangaIds`.
  Future<List<Manga>> fetchMangaByIds(List<String> mangaIds) async {
    if (mangaIds.isEmpty) {
      return <Manga>[];
    }

    final queryParameters = <String, dynamic>{
      'ids[]': mangaIds,
      'includes[]': 'cover_art',
      'hasAvailableChapters': '1', // Luôn bật mặc định
    };
    final Uri url = Uri.parse(
      '$baseUrl/manga',
    ).replace(queryParameters: queryParameters);

    try {
      final http.Response response = await _client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        final listResponse = ListResponse<Manga>.fromJson(
          data,
          (json) => Manga.fromJson(json as Map<String, dynamic>),
        );
        return listResponse.data;
      } else {
        throw Exception('Failed to fetch manga: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching manga: $error');
    }
  }
}
```

Với thay đổi này, tất cả các chức năng tìm kiếm, hiển thị danh sách truyện trong ứng dụng của bạn sẽ mặc định chỉ lấy những manga có chapter sẵn có, đúng như yêu cầu.

Nếu có bất kỳ câu hỏi nào khác, đừng ngần ngại hỏi nhé