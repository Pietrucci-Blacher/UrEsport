import 'package:uresport/core/models/team.dart';
import 'package:uresport/core/models/tournament.dart';

class Match {
  final int id;
  final int tournamentId;
  final Tournament? tournament;
  final int? team1Id;
  final int? team2Id;
  final Team? team1;
  final Team? team2;
  final int? winnerId;
  final String status;
  final int score1;
  final int score2;
  final bool team1Close;
  final bool team2Close;
  final int? nextMatchId;
  final int depth;

  Match({
    required this.id,
    required this.tournamentId,
    required this.tournament,
    required this.team1Id,
    required this.team2Id,
    required this.team1,
    required this.team2,
    required this.winnerId,
    required this.status,
    required this.score1,
    required this.score2,
    required this.team1Close,
    required this.team2Close,
    required this.nextMatchId,
    required this.depth,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      tournamentId: json['tournament_id'],
      tournament: json['tournament'] != null
          ? Tournament.fromJson(json['tournament'])
          : null,
      team1Id: json['team1_id'],
      team2Id: json['team2_id'],
      team1: json['team1'] != null ? Team.fromJson(json['team1']) : null,
      team2: json['team2'] != null ? Team.fromJson(json['team2']) : null,
      winnerId: json['winner_id'],
      status: json['status'],
      score1: json['score1'],
      score2: json['score2'],
      team1Close: json['team1_close'],
      team2Close: json['team2_close'],
      nextMatchId: json['next_match_id'],
      depth: json['depth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournament_id': tournamentId,
      'tournament': tournament?.toJson(),
      'team1_id': team1Id,
      'team2_id': team2Id,
      'team1': team1?.toJson(),
      'team2': team2?.toJson(),
      'winner_id': winnerId,
      'status': status,
      'score1': score1,
      'score2': score2,
      'team1_close': team1Close,
      'team2_close': team2Close,
      'next_match_id': nextMatchId,
      'depth': depth,
    };
  }

  Team? getWinner() {
    if (winnerId == team1Id) {
      return team1!;
    } else if (winnerId == team2Id) {
      return team2!;
    } else {
      return null;
    }
  }
}
