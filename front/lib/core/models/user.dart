class User {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? avatarUrl;

  User({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstname'],
      lastName: json['lastname'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }
}
