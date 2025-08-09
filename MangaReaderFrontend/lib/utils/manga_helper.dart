import 'package:manga_reader_app/data/models/manga/manga.dart';

extension MangaHelper on Manga {
  /// Lấy tiêu đề hiển thị một cách an toàn.
  ///
  /// Ưu tiên tìm trong `title`, sau đó đến `altTitles` theo danh sách ngôn ngữ.
  /// Nếu không có, sẽ lấy tiêu đề có sẵn đầu tiên.
  String getDisplayTitle({List<String> preferredLanguages = const ['vi', 'en']}) {
    // 1. Tìm trong trường `title` chính
    for (final String lang in preferredLanguages) {
      if (attributes.title.containsKey(lang) && attributes.title[lang]!.isNotEmpty) {
        return attributes.title[lang]!;
      }
    }

    // 2. Tìm trong trường `altTitles`
    for (final String lang in preferredLanguages) {
      for (final dynamic alt in attributes.altTitles) {
        if (alt is Map<String, dynamic> && alt.containsKey(lang)) {
          final String altTitle = alt[lang] as String;
          if (altTitle.isNotEmpty) {
            return altTitle;
          }
        }
      }
    }

    // 3. Lấy tiêu đề đầu tiên có sẵn trong `title`
    if (attributes.title.values.isNotEmpty) {
      final String firstTitle = attributes.title.values.first;
      if (firstTitle.isNotEmpty) {
        return firstTitle;
      }
    }

    // 4. Lấy tiêu đề đầu tiên có sẵn trong `altTitles`
    if (attributes.altTitles.isNotEmpty) {
      for (final dynamic alt in attributes.altTitles) {
        if (alt is Map<String, dynamic> && alt.values.isNotEmpty) {
          final String firstAltTitle = alt.values.first as String;
          if(firstAltTitle.isNotEmpty) {
            return firstAltTitle;
          }
        }
      }
    }
    
    // 5. Nếu không có gì, trả về mặc định
    return 'Không có tiêu đề';
  }

  /// Lấy mô tả hiển thị một cách an toàn.
  String getDisplayDescription({List<String> preferredLanguages = const ['vi', 'en']}) {
    for (final String lang in preferredLanguages) {
      if (attributes.description.containsKey(lang) && attributes.description[lang]!.isNotEmpty) {
        return attributes.description[lang]!;
      }
    }
    if (attributes.description.isNotEmpty) {
      final String firstDesc = attributes.description.values.first;
      if (firstDesc.isNotEmpty) {
        return firstDesc;
      }
    }
    return 'Không có mô tả.';
  }
}


