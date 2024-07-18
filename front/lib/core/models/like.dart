import 'game.dart';

class Like {
  final int? id; // ID can be null for new likes
  final int userId;
  final int gameId;
  final Game game;

  Like({
    this.id,
    required this.userId,
    required this.gameId,
    required this.game,
  });

  Like copyWith({
    int? id,
    int? userId,
    int? gameId,
    Game? game,
  }) {
    return Like(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      gameId: gameId ?? this.gameId,
      game: game ?? this.game,
    );
  }

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      userId: json['user_id'],
      gameId: json['game_id'],
      game: Game.fromJson(json['game']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'game_id': gameId,
      'game': game.toJson(),
    };
  }
}
