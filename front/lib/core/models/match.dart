import 'package:uresport/core/models/team.dart';

class Match {
  final int id;
  final int tournamentId;
  final int? team1Id;
  final int? team2Id;
  final Team? team1;
  final Team? team2;
  final int? winnerId;
  final int score1;
  final int score2;
  final int? nextMatchId;
  final int depth;

  Match({
    required this.id,
    required this.tournamentId,
    required this.team1Id,
    required this.team2Id,
    required this.team1,
    required this.team2,
    required this.winnerId,
    required this.score1,
    required this.score2,
    required this.nextMatchId,
    required this.depth,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      tournamentId: json['tournament_id'],
      team1Id: json['team1_id'],
      team2Id: json['team2_id'],
      team1: json['team1'] != null ? Team.fromJson(json['team1']) : null,
      team2: json['team2'] != null ? Team.fromJson(json['team2']) : null,
      winnerId: json['winner_id'],
      score1: json['score1'],
      score2: json['score2'],
      nextMatchId: json['next_match_id'],
      depth: json['depth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournament_id': tournamentId,
      'team1_id': team1Id,
      'team2_id': team2Id,
      'team1': team1?.toJson(),
      'team2': team2?.toJson(),
      'winner_id': winnerId,
      'score1': score1,
      'score2': score2,
      'next_match_id': nextMatchId,
      'depth': depth,
    };
  }
}
