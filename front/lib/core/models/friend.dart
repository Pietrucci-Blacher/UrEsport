class Friend {
  final int id;
  final int userId;
  final String name;
  bool isFavorite;

  Friend({
    required this.id,
    required this.userId,
    required this.name,
    this.isFavorite = false,
  });

  Friend copyWith({
    int? id,
    int? userId,
    String? name,
    bool? isFavorite,
  }) {
    return Friend(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['firstname'] ?? 'Unknown',
      isFavorite: json['favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'favorite': isFavorite,
    };
  }
}
