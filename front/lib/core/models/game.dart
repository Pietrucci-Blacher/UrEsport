import 'package:uresport/core/models/tournament.dart';

class Game {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final List<Tournament> tournaments;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tournaments,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      tournaments: (json['tournaments'] as List)
          .map((tournament) => Tournament.fromJson(tournament))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': imageUrl,
      'tournaments': tournaments.map((tournament) => tournament.toJson()).toList(),
    };
  }
}
