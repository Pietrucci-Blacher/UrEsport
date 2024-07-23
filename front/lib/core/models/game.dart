class Game {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final String createdAt;
  final String updatedAt;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  Game copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? tags,
    String? createdAt,
    String? updatedAt,
  }) {
    return Game(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': imageUrl,
      'tags': tags,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
