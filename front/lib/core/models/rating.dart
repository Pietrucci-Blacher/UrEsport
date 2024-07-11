class Rating {
  final int id;
  final int tournamentId;
  final int userId;
  final double rating;

  Rating({
    required this.id,
    required this.tournamentId,
    required this.userId,
    required this.rating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      tournamentId: json['tournament_id'],
      userId: json['user_id'],
      rating: json['rating'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournament_id': tournamentId,
      'user_id': userId,
      'rating': rating,
    };
  }
}
