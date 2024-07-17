import 'package:uresport/core/models/team.dart';
import 'game.dart';

class Tournament {
  final int id;
  late final String name;
  late final String description;
  late final DateTime startDate;
  late final DateTime endDate;
  late final String location;
  late final double latitude;
  late final double longitude;
  late final String image;
  late final bool isPrivate;
  late final int ownerId;
  final Owner owner;
  late final List<Team> teams;
  late final int nbPlayers;
  final int upvotes;
  final Game game;

  Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.image,
    required this.isPrivate,
    required this.ownerId,
    required this.owner,
    required this.teams,
    required this.nbPlayers,
    required this.upvotes,
    required this.game,
  });

  Tournament copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    double? latitude,
    double? longitude,
    String? image,
    bool? isPrivate,
    int? ownerId,
    Owner? owner,
    List<Team>? teams,
    int? nbPlayers,
    int? upvotes,
    Game? game,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      image: image ?? this.image,
      isPrivate: isPrivate ?? this.isPrivate,
      ownerId: ownerId ?? this.ownerId,
      owner: owner ?? this.owner,
      teams: teams ?? this.teams,
      nbPlayers: nbPlayers ?? this.nbPlayers,
      upvotes: upvotes ?? this.upvotes,
      game: game ?? this.game,
    );
  }

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      location: json['location'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      image: json['image'],
      isPrivate: json['private'],
      ownerId: json['owner_id'],
      owner: Owner.fromJson(json['owner']),
      teams: (json['teams'] as List?)?.map((team) => Team.fromJson(team)).toList() ?? [],
      nbPlayers: json['nb_player'] ?? 1,
      upvotes: json['upvotes'] ?? 0,
      game: Game.fromJson(json['game']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
      'private': isPrivate,
      'owner_id': ownerId,
      'owner': owner.toJson(),
      'teams': teams.map((team) => team.toJson()).toList(),
      'nb_player': nbPlayers,
      'upvotes': upvotes,
      'game': game.toJson(),
    };
  }
}

class Owner {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final List<Team>? teams;
  final DateTime createdAt;
  final DateTime updatedAt;

  Owner({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    this.teams,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      teams: (json['teams'] as List?)?.map((team) => Team.fromJson(team)).toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'teams': teams?.map((team) => team.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Member {
  final int id;
  final String username;
  final String firstname;
  final String lastname;

  Member({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}
