class Game {
  final int id;
  late final String name;
  late final String description;
  late final String imageUrl;
  late final List<String> tags;
  late final String createdAt;
  late final String updatedAt;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

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
