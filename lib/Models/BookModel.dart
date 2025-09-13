class BookModel {
  final String? key;
  final String? title;
  final List<String>? authors;
  final List<String>? authorKeys;
  final String? firstPublishYear;
  final List<String>? isbn;
  final int? coverId;
  final String? description;
  final List<String>? subjects;
  final double? averageRating;
  final int? ratingsCount;
  final String? language;
  final int? pageCount;

  BookModel({
    this.key,
    this.title,
    this.authors,
    this.authorKeys,
    this.firstPublishYear,
    this.isbn,
    this.coverId,
    this.description,
    this.subjects,
    this.averageRating,
    this.ratingsCount,
    this.language,
    this.pageCount,
  });

  // From search results JSON
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      key: json['key'] as String?,
      title: json['title'] as String?,
      authors: (json['author_name'] as List<dynamic>?)
          ?.map((author) => author.toString())
          .toList(),
      authorKeys: (json['author_key'] as List<dynamic>?)
          ?.map((key) => key.toString())
          .toList(),
      firstPublishYear: json['first_publish_year']?.toString(),
      isbn: (json['isbn'] as List<dynamic>?)
          ?.map((isbn) => isbn.toString())
          .toList(),
      coverId: json['cover_i'] as int?,
      subjects: (json['subject'] as List<dynamic>?)
          ?.map((subject) => subject.toString())
          .toList(),
      averageRating: (json['ratings_average'] as num?)?.toDouble(),
      ratingsCount: json['ratings_count'] as int?,
      language: (json['language'] as List<dynamic>?)?.first?.toString(),
      pageCount: json['number_of_pages_median'] as int?,
    );
  }

  // From subject/category results JSON
  factory BookModel.fromSubjectJson(Map<String, dynamic> json) {
    return BookModel(
      key: json['key'] as String?,
      title: json['title'] as String?,
      authors: (json['authors'] as List<dynamic>?)
          ?.map((author) => author['name']?.toString() ?? 'Unknown Author')
          .toList(),
      authorKeys: (json['authors'] as List<dynamic>?)
          ?.map((author) => author['key']?.toString() ?? '')
          .toList(),
      firstPublishYear: json['first_publish_year']?.toString(),
      coverId: json['cover_id'] as int?,
      subjects: (json['subject'] as List<dynamic>?)
          ?.map((subject) => subject.toString())
          .toList(),
    );
  }

  // From work details JSON
  factory BookModel.fromWorkJson(Map<String, dynamic> json) {
    String? desc;
    if (json['description'] != null) {
      if (json['description'] is String) {
        desc = json['description'];
      } else if (json['description'] is Map) {
        desc = json['description']['value'];
      }
    }

    return BookModel(
      key: json['key'] as String?,
      title: json['title'] as String?,
      authorKeys: (json['authors'] as List<dynamic>?)
          ?.map((author) => author['author']?['key']?.toString() ?? '')
          .toList(),
      firstPublishYear: json['first_publish_year']?.toString(),
      description: desc,
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((subject) => subject.toString())
          .toList(),
      coverId: (json['covers'] as List<dynamic>?)?.first as int?,
    );
  }

  // Helper getters
  String get displayTitle => title ?? 'Unknown Title';
  String get displayAuthor => authors?.first ?? 'Unknown Author';
  String get displayYear => firstPublishYear ?? '';

  String get authorNames {
    if (authors != null && authors!.isNotEmpty) {
      return authors!.join(', ');
    }
    return 'Unknown Author';
  }

  String get workId {
    if (key != null) {
      return key!.split('/').last;
    }
    return '';
  }

  String get firstAuthorKey {
    if (authorKeys != null && authorKeys!.isNotEmpty) {
      return authorKeys!.first.split('/').last;
    }
    return '';
  }

  @override
  String toString() {
    return 'BookModel(title: $title, authors: $authors, year: $firstPublishYear)';
  }
}
