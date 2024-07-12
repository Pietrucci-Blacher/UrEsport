// lib/models/game.dart
class Game {
  final int id;
  late final String name;
  late final String description;
  late final String image;
  late final String tags;
  late final String createdAt;
  late final String updatedAt;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });
}
