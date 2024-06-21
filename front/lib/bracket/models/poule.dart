import 'package:uresport/bracket/models/team.dart';

class Poule {
  Poule({
    required this.name,
    required this.teams,
  });

  final String name;
  final List<Team> teams;
}
