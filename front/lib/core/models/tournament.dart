class Tournament {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String image;
  final bool isPrivate;
  final int organizer;
  final List<Participant> participants;

  Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.image,
    required this.isPrivate,
    required this.organizer,
    required this.participants,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      location: json['location'],
      image: json['image'],
      isPrivate: json['private'],
      organizer: json['organizer'],
      participants: (json['participants'] as List)
          .map((participant) => Participant.fromJson(participant))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'image': image,
      'private': isPrivate,
      'organizer': organizer,
      'participants':
          participants.map((participant) => participant.toJson()).toList(),
    };
  }
}

class Participant {
  final int id;
  final String username;
  final String firstname;
  final String lastname;

  Participant({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}
