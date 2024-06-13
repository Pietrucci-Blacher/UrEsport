class Tournament {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String image;
  final bool isPrivate;
  final int ownerId;
  final Owner owner;
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
    required this.ownerId,
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
      ownerId: json['owner_id'],
      owner: Owner.fromJson(json['owner']),
      teams: (json['teams'] as List)
          .map((team) => Team.fromJson(team))
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
      'ownerId': ownerId,
      'owner': owner.toJson(),
      'teams': teams.map((team) => team.toJson()).toList(),
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
      teams: json['teams'] != null
          ? (json['teams'] as List).map((team) => Team.fromJson(team)).toList()
          : null,
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
  final List<Member>? members;
  final List<Tournament>? tournaments;
  final Owner owner;
  final int ownerId;
  final bool isPrivate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Team({
    required this.id,
    required this.name,
    this.members,
    this.tournaments,
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
      members: json['members'] != null
          ? (json['members'] as List).map((member) => Member.fromJson(member)).toList()
          : null,
      tournaments: json['tournaments'] != null
          ? (json['tournaments'] as List).map((tournament) => Tournament.fromJson(tournament)).toList()
          : null,
      owner: Owner.fromJson(json['owner']),
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
      'members': members?.map((member) => member.toJson()).toList(),
      'tournaments': tournaments?.map((tournament) => tournament.toJson()).toList(),
      'owner': owner.toJson(),
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
