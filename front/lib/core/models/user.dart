import 'package:uresport/core/models/team.dart';

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String? profileImageUrl;
  final List<dynamic> roles;
  final List<Team> teams;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    this.profileImageUrl,
    required this.roles,
    required this.teams,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profile_image_url'],
      roles: json['roles'] ?? [],
      teams: (json['teams'] as List<dynamic>?)
              ?.map((teamJson) => Team.fromJson(teamJson))
              .toList() ??
          [],
    );
  }

  User copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? username,
    String? email,
    String? profileImageUrl,
    List<dynamic>? roles,
    List<Team>? teams,
  }) {
    return User(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      roles: roles ?? this.roles,
      teams: teams ?? this.teams,
    );
  }
}
