class Game {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
