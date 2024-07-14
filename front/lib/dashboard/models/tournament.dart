class DashboardTournament {
  final int id;
  late String name;
  late String description;
  late String startDate;
  late String endDate;
  late String location;
  late double latitude;
  late double longitude;
  late int ownerId;
  late String image;
  late bool private;
  late int gameId;
  late int nbPlayer;
  late String createdAt;
  late String updatedAt;
  late int upvotes;

  DashboardTournament({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
    required this.image,
    required this.private,
    required this.gameId,
    required this.nbPlayer,
    required this.createdAt,
    required this.updatedAt,
    required this.upvotes,
  });

  factory DashboardTournament.fromJson(Map<String, dynamic> json) {
    return DashboardTournament(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      ownerId: json['ownerId'],
      image: json['image'],
      private: json['private'],
      gameId: json['gameId'],
      nbPlayer: json['nbPlayer'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      upvotes: json['upvotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
      'image': image,
      'private': private,
      'gameId': gameId,
      'nbPlayer': nbPlayer,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'upvotes': upvotes,
    };
  }
}
