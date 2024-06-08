class Game {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final int spectators;
  final List<String> categories;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.spectators,
    required this.categories,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image'],
      spectators: json['spectators'] ?? 0,
      categories: List<String>.from(json['categories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': imageUrl,
      'spectators': spectators,
      'categories': categories,
    };
  }
}
