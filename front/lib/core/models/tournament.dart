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
  late final int nbPlayer;
  late final int upvotes;
  late final Game game;

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
    required this.nbPlayer,
    required this.upvotes,
    required this.game,
  });

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
      teams:
          ((json['teams'] ?? []) as List).map((team) => Team.fromJson(team)).toList(),
      nbPlayer: json['nb_player'] ?? 1,
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
      'nb_player': nbPlayer,
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
      teams:
          (json['teams'] as List?)?.map((team) => Team.fromJson(team)).toList(),
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

class Team {
  final int id;
  final String name;
  final List<dynamic> members; // Utiliser List<dynamic> pour les membres
  final List<dynamic> tournaments; // Utiliser List<dynamic> pour les tournois
  final Map<String, dynamic> owner; // Utiliser Map pour le propriétaire
  final int ownerId;
  final bool isPrivate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Team({
    required this.id,
    required this.name,
    required this.members,
    required this.tournaments,
    required this.owner,
    required this.ownerId,
    required this.isPrivate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      members: json['members'] ?? [], // Assurer une liste vide si null
      tournaments: json['tournaments'] ?? [], // Assurer une liste vide si null
      owner: json['owner'] ?? {}, // Assurer une map vide si null
      ownerId: json['owner_id'],
      isPrivate: json['private'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'members': members, // Pas besoin de transformer en JSON
      'tournaments': tournaments, // Pas besoin de transformer en JSON
      'owner': owner, // Pas besoin de transformer en JSON
      'owner_id': ownerId,
      'private': isPrivate,
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
