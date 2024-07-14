// lib/models/tournament.dart
class Tournament {
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

  Tournament({
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
}
