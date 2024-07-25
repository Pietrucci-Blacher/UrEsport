class Team {
  final int id;
  final String name;
  final List<dynamic> members;
  final List<dynamic> tournaments;
  final Map<String, dynamic> owner;
  final int ownerId;
  final bool isPrivate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasJoined; // Nouvelle propriété

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
    required this.hasJoined, // Assurez-vous d'initialiser cette propriété
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      members: json['members'] ?? [],
      tournaments: json['tournaments'] ?? [],
      owner: json['owner'] ?? {},
      ownerId: json['owner_id'],
      isPrivate: json['private'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      hasJoined: json['hasJoined'] ?? false, // Lecture de la propriété
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'tournaments': tournaments,
      'owner': owner,
      'owner_id': ownerId,
      'private': isPrivate,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'hasJoined': hasJoined, // Écriture de la propriété
    };
  }

  int get memberCount => members.length;
}
