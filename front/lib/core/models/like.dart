class Like {
  final int? id; // ID can be null for new likes
  final int userId;
  final int gameId;

  Like({
    this.id,
    required this.userId,
    required this.gameId,
  });

  Like copyWith({
    int? id,
    int? userId,
    int? gameId,
  }) {
    return Like(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      gameId: gameId ?? this.gameId,
    );
  }

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      userId: json['user_id'],
      gameId: json['game_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'game_id': gameId,
    };
  }
}
