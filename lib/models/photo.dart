class SearchResult {
  final int total;
  final int totalPages;
  final List<Photo> results;

  SearchResult({
    required this.total,
    required this.totalPages,
    required this.results,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      results: (json['results'] as List)
          .map((photo) => Photo.fromJson(photo))
          .toList(),
    );
  }
}

class Photo {
  final String id;
  final Map<String, String> urls;
  final User user;
  final String? description;
  final String? altDescription;
  final int likes;
  final DateTime createdAt;
  final bool isFavorite;

  Photo({
    required this.id,
    required this.urls,
    required this.user,
    this.description,
    this.altDescription,
    required this.likes,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      urls: Map<String, String>.from(json['urls']),
      user: User.fromJson(json['user']),
      description: json['description'],
      altDescription: json['alt_description'],
      likes: json['likes'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'urls': urls,
        'user': user.toJson(),
        'description': description,
        'alt_description': altDescription,
        'likes': likes,
        'created_at': createdAt.toIso8601String(),
        'is_favorite': isFavorite,
      };

  Photo copyWith({
    String? id,
    Map<String, String>? urls,
    User? user,
    String? description,
    String? altDescription,
    int? likes,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return Photo(
      id: id ?? this.id,
      urls: urls ?? this.urls,
      user: user ?? this.user,
      description: description ?? this.description,
      altDescription: altDescription ?? this.altDescription,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class User {
  final String id;
  final String username;
  final String name;
  final String? profileImage;

  User({
    required this.id,
    required this.username,
    required this.name,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      profileImage: json['profile_image']?['medium'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'name': name,
        'profile_image': profileImage != null ? {'medium': profileImage} : null,
      };
}
