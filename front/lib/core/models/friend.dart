import 'package:intl/intl.dart';

class Friend {
  final int id;
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String profileImageUrl;
  final List<String> roles;
  final dynamic teams;
  final bool verified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  bool isFavorite;

  Friend({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.roles,
    this.teams,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.isFavorite = false,
  });

  Friend copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? username,
    String? email,
    String? profileImageUrl,
    List<String>? roles,
    dynamic teams,
    bool? verified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isFavorite,
  }) {
    return Friend(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      roles: roles ?? this.roles,
      teams: teams ?? this.teams,
      verified: verified ?? this.verified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Friend.fromJson(Map<String, dynamic> json,
      {bool isFavorite = false}) {
    return Friend(
      id: json['id'] ?? 0,
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profile_image_url'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      teams: json['teams'],
      verified: json['verified'] ?? false,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? _parseDateTime(json['deleted_at'])
          : null,
      isFavorite: isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'profile_image_url': profileImageUrl,
      'roles': roles,
      'teams': teams,
      'verified': verified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  static DateTime _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ");
      try {
        return formatter.parse(dateString);
      } catch (e) {
        return DateTime.now();
      }
    }
  }
}
