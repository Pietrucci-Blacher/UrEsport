class Friend {
  final String name;
  bool isFavorite;

  Friend({
    required this.name,
    this.isFavorite = false,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      name: json['firstname'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isFavorite': isFavorite,
    };
  }
}
