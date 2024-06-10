import 'package:uresport/core/models/tournament.dart';

class Team {
    final int id;
    final String name;
    final bool private;
    final int owner;
    // final List<User> members;
    final List<Tournament> tournaments;

    Team({
        required this.id,
        required this.name,
        required this.private,
        required this.owner,
        // required this.members,
        required this.tournaments,
    });

    factory Team.fromJson(Map<String, dynamic> json) {
        return Team(
            id: json['id'],
            name: json['name'],
            private: json['private'],
            owner: json['owner'],
            // members: (json['members'] as List)
            //     .map((user) => User.fromJson(user))
            //     .toList(),
            tournaments: (json['tournaments'] as List)
                .map((tournament) => Tournament.fromJson(tournament))
                .toList(),
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'name': name,
            'private': private,
            'owner': owner,
            // 'members': members.map((member) => member.toJson()).toList(),
            'tournaments': tournaments.map((tournament) => tournament.toJson()).toList(),
        };
    }
}
