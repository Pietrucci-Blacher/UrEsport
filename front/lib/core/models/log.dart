class Log {
  final int id;
  final String type;
  final List<String> tags;
  final DateTime date;
  final String text;

  Log({
    required this.id,
    required this.type,
    required this.tags,
    required this.date,
    required this.text,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      type: json['type'],
      tags: (json['tags'] as List).map((tag) => tag.toString()).toList(),
      date: DateTime.parse(json['date']),
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'tags': tags,
      'date': date.toIso8601String(),
      'text': text,
    };
  }
}
