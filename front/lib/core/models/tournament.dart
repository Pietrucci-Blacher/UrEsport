import 'package:uresport/core/models/team.dart';

class Tournament {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String image;
  final bool isPrivate;
  final int owner;
  final List<Team> teams;

  Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.image,
    required this.isPrivate,
    required this.owner,
    required this.teams,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      location: json['location'],
      image: json['image'],
      isPrivate: json['private'],
      owner: json['owner'],
      teams: (json['teams'] as List)
          .map((participant) => Team.fromJson(participant))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'image': image,
      'private': isPrivate,
      'owner': owner,
      'teams': teams.map((team) => team.toJson()).toList(),
    };
  }
}
