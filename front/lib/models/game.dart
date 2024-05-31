class Game {
  final int id;
  final String name;
  final String imageUrl;
  final String description;

  Game({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
