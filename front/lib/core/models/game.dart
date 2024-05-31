class Game {
  final int id;
  final String name;
  final String imageUrl;
  final String description;

  const Game({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['name'] == null || json['imageUrl'] == null || json['description'] == null) {
      throw ArgumentError('Invalid JSON: missing required keys');
    }

    return Game(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
