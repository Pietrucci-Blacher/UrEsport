import 'package:uresport/core/models/team.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/models/user.dart';

class Invit {
  final int id;
  final Tournament tournament;
  final User user;
  final Team team;
  final String type;
  final String status;
  late String message;

  Invit({
    required this.id,
    required this.tournament,
    required this.user,
    required this.team,
    required this.type,
    required this.status,
  }) {
    if (type == 'tournament') {
      message = 'you have been invited to the tournament ${tournament.name}';
    } else if (type == 'team') {
      message = 'you have been invited to the team ${team.name}';
    } else {
      message = 'Unknown invitation type';
    }
  }

  factory Invit.fromJson(Map<String, dynamic> json) {
    return Invit(
      id: json['id'],
      tournament: Tournament.fromJson(json['tournament']),
      user: User.fromJson(json['user']),
      team: Team.fromJson(json['team']),
      type: json['type'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournament': tournament.toJson(),
      'user': user.toJson(),
      'team': team.toJson(),
      'type': type,
      'status': status,
    };
  }
}
