import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:manga_reader_app/data/models/author.dart';
import 'package:manga_reader_app/data/models/manga/manga_statistics.dart';
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
    MangaSearchQuery? sortManga,
    List<String>? includes,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'hasAvailableChapters': '1',
      'hasUnavailableChapters': '0',
    };

    final List<String> finalIncludes = <String>{'cover_art', ...?includes}.toList();
    params['includes[]'] = finalIncludes;

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
    http.Response response;
    try {
      response = await _client.get(uri);
    } catch (e) {
      final message = e.toString();
      if (message.contains('Connection closed before full header was received')) {
        // Retry sau 5s một lần
        await Future.delayed(const Duration(seconds: 5));
        response = await _client.get(uri);
      } else {
        rethrow;
      }
    }

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
      'includes[]': ['author', 'artist', 'cover_art']
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

    /// Tìm kiếm tác giả/họa sĩ theo tên.
  Future<List<Author>> searchAuthors(String name) async {
    if (name.isEmpty) return [];

    final Map<String, dynamic> params = <String, dynamic>{
      'name': name,
      'limit': '10',
    };
    final Uri uri = Uri.parse('$baseUrl/author').replace(queryParameters: params);
    final http.Response response = await _client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final listResponse = ListResponse<Author>.fromJson(
        data,
        (json) => Author.fromJson(json as Map<String, dynamic>),
      );
      return listResponse.data;
    } else {
      logError('searchAuthors', response);
      // Trả về mảng rỗng thay vì ném lỗi để không làm gián đoạn UI
      return [];
    }
  }

  /// Lấy thông tin thống kê của một manga.
  Future<MangaStatisticsData> fetchMangaStatistics(String mangaId) async {
    final uri = Uri.parse('$baseUrl/statistics/manga/$mangaId');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final statsResponse = MangaStatisticsResponse.fromJson(data);
      if (statsResponse.statistics.containsKey(mangaId)) {
        return statsResponse.statistics[mangaId]!;
      } else {
        throw Exception('Không tìm thấy thống kê cho manga ID: $mangaId');
      }
    } else {
      logError('fetchMangaStatistics', response);
      throw Exception('Lỗi khi tải thống kê manga: ${response.statusCode}');
    }
  }

  /// Lấy danh sách các chapter của một manga theo ngôn ngữ, thứ tự, và giới hạn.
  Future<List<dynamic>> fetchChapters(
    String mangaId,
    List<String> languages, {
    String order = 'desc',
    int? limit,
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
    
    // Nếu có limit, chỉ cần gọi API một lần với limit đó.
    if (limit != null) {
      final queryParameters = <String, dynamic>{
        'limit': limit.toString(),
        'offset': '0',
        'order[chapter]': order,
        'translatedLanguage[]': validLanguages,
      };
      final uri = Uri.parse('$baseUrl/manga/$mangaId/feed')
          .replace(queryParameters: queryParameters);
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['data'] as List<dynamic>;
      } else {
         logError('fetchChapters (limited)', response);
        throw Exception(
          'Lỗi khi tải ${limit} chapter: ${response.statusCode}',
        );
      }
    }
    
    // Logic cũ để tải tất cả chapter (phân trang)
    final List<dynamic> allChapters = <dynamic>[];
    int offset = 0;
    const int pageSize = 100;

    while (true) {
      final Map<String, dynamic> queryParameters = <String, dynamic>{
        'limit': pageSize.toString(),
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
          break; // Không còn chapter nào nữa
        }

        allChapters.addAll(chapters);
        offset += pageSize;
      } else if (response.statusCode == 503) {
        throw Exception(
          'Máy chủ MangaDex hiện đang bảo trì, xin vui lòng thử lại sau!',
        );
      } else {
        logError('fetchChapters (paginated)', response);
        throw Exception(
          'Lỗi trong hàm fetchChapters:\nMã trạng thái: ${response.statusCode}',
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
      'hasAvailableChapters': '1',
      'hasUnavailableChapters': '0',
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