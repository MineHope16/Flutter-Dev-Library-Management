class AuthorDetailModel {
  final String? key;
  final String? name;
  final String? bio;
  final String? birthDate;
  final String? deathDate;
  final List<String>? alternateNames;
  final int? photoId;
  final String? wikipedia;
  final List<String>? links;

  AuthorDetailModel({
    this.key,
    this.name,
    this.bio,
    this.birthDate,
    this.deathDate,
    this.alternateNames,
    this.photoId,
    this.wikipedia,
    this.links,
  });

  factory AuthorDetailModel.fromJson(Map<String, dynamic> json) {
    String? biography;
    if (json['bio'] != null) {
      if (json['bio'] is String) {
        biography = json['bio'];
      } else if (json['bio'] is Map) {
        biography = json['bio']['value'];
      }
    }

    return AuthorDetailModel(
      key: json['key'] as String?,
      name: json['name'] as String?,
      bio: biography,
      birthDate: json['birth_date'] as String?,
      deathDate: json['death_date'] as String?,
      alternateNames: (json['alternate_names'] as List<dynamic>?)
          ?.map((name) => name.toString())
          .toList(),
      photoId: (json['photos'] as List<dynamic>?)?.first as int?,
      wikipedia: json['wikipedia'] as String?,
      links: (json['links'] as List<dynamic>?)
          ?.map((link) => link['url']?.toString() ?? '')
          .where((url) => url.isNotEmpty)
          .toList(),
    );
  }

  // Helper getters
  String get displayName => name ?? 'Unknown Author';
  String get displayBio => bio ?? 'No biography available.';

  String get lifeSpan {
    if (birthDate != null && deathDate != null) {
      return '$birthDate - $deathDate';
    } else if (birthDate != null) {
      return '$birthDate - Present';
    } else if (deathDate != null) {
      return 'Unknown - $deathDate';
    }
    return 'Unknown';
  }

  String get authorId {
    if (key != null) {
      return key!.split('/').last;
    }
    return '';
  }

  String get photoUrl {
    if (photoId != null) {
      return 'https://covers.openlibrary.org/a/id/$photoId-M.jpg';
    }
    return '';
  }

  @override
  String toString() {
    return 'AuthorDetailModel(name: $name, birthDate: $birthDate, deathDate: $deathDate)';
  }
}
