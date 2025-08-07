import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/logger.dart';
import '../models/manga/cover.dart';
import '../models/manga/list_response.dart';
import '../models/manga/manga.dart';
import '../models/manga/tag.dart';
import '../models/sort_manga_model.dart';

class MangaDexApiService {
  final String baseUrl = 'https://api.mangadex.org';

  // Ghi log lỗi với thông tin chi tiết
  void logError(String functionName, http.Response response) {
    logger.e(
      'Lỗi trong hàm $functionName',
      error: 'Mã trạng thái: ${response.statusCode}',
      stackTrace: StackTrace.fromString('Nội dung phản hồi: ${response.body}'),
    );
  }

  Future<List<Manga>> fetchManga({
    int? limit,
    int? offset,
    SortManga? sortManga,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'includes[]': 'cover_art', // Luôn lấy cover art
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
    final http.Response response = await http.get(uri);

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

  Future<Manga> fetchMangaDetails(String mangaId) async {
    final Map<String, String> params = <String, String>{'includes[]': 'author'};
    final Uri uri = Uri.parse(
      '$baseUrl/manga/$mangaId',
    ).replace(queryParameters: params);
    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Manga.fromJson(data['data'] as Map<String, dynamic>);
    } else {
      logError('fetchMangaDetails', response);
      throw Exception('Lỗi khi tải chi tiết manga');
    }
  }

  Future<List<dynamic>> fetchChapters(
    String mangaId,
    String languages, {
    String order = 'desc',
    int? maxChapters,
  }) async {
    final List<String> languageList = languages
        .split(',')
        .map((String lang) => lang.trim())
        .toList();
    languageList.removeWhere(
      (String lang) => !RegExp(r'^[a-z]{2}(-[a-z]{2})?$').hasMatch(lang),
    );

    if (languageList.isEmpty) {
      throw Exception(
        'Danh sách ngôn ngữ không hợp lệ. Vui lòng kiểm tra cài đặt.',
      );
    }

    final List<dynamic> allChapters = <dynamic>[];
    int offset = 0;
    const int limit = 100;

    while (true) {
      final http.Response response = await http.get(
        Uri.parse(
          '$baseUrl/manga/$mangaId/feed?limit=$limit&offset=$offset&translatedLanguage[]=${languageList.join('&translatedLanguage[]=')}&order[chapter]=$order',
        ),
      );

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

  Future<String> fetchCoverUrl(String mangaId) async {
    final Uri uri = Uri.parse(
      '$baseUrl/cover',
    ).replace(queryParameters: <String, String>{'manga[]': mangaId});
    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final listResponse = ListResponse<Cover>.fromJson(
        data,
        (json) => Cover.fromJson(json as Map<String, dynamic>),
      );

      if (listResponse.data.isNotEmpty) {
        final String coverFileName =
            listResponse.data.first.attributes.fileName;
        return 'https://uploads.mangadex.org/covers/$mangaId/$coverFileName.512.jpg';
      } else {
        // Trả về một URL ảnh bìa mặc định hoặc ném lỗi rõ ràng hơn
        throw Exception('Không tìm thấy ảnh bìa cho manga $mangaId');
      }
    } else {
      logError('fetchCoverUrl', response);
      throw Exception('Lỗi khi tải ảnh bìa');
    }
  }

  Future<List<String>> fetchChapterPages(String chapterId) async {
    final http.Response response = await http.get(
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

  Future<List<Tag>> fetchTags() async {
    final http.Response response = await http.get(
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

  Future<List<Manga>> fetchMangaByIds(List<String> mangaIds) async {
    if (mangaIds.isEmpty) {
      return <Manga>[];
    }

    final queryParameters = <String, dynamic>{
      'ids[]': mangaIds,
      'includes[]': 'cover_art',
    };
    final Uri url = Uri.parse(
      '$baseUrl/manga',
    ).replace(queryParameters: queryParameters);

    try {
      final http.Response response = await http.get(url);

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
