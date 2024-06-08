class Game {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> tags;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tags,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': imageUrl,
      'tags': tags,
    };
  }
}
