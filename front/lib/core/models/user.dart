class User {
  final int id;
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String? profileImageUrl;
  final List<dynamic> roles;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    this.profileImageUrl,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      email: json['email'],
      profileImageUrl: json['profile_image_url'],
      roles: json['roles'],
    );
  }

  User copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? username,
    String? email,
    String? profileImageUrl,
  }) {
    return User(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      roles: roles,
    );
  }
}
