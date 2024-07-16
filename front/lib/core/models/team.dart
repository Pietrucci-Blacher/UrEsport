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
