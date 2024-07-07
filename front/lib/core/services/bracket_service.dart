import 'package:uresport/core/models/match.dart';

class BracketService {
  List<List<Match>> bracket = [];

  BracketService(List<Match>? matches) {
    if (matches == null) {
      return;
    }
    generateBracket(matches);
  }

  void generateBracket(List<Match> matches) {
    bracket = [];
    for (var i = 0; i < matches.length; i++) {
      var depth = matches[i].depth;
      bracket[depth].add(matches[i]);
    }
  }

  List<Match> getMatches(int depth) {
    return bracket[depth];
  }

  List<List<Match>> getBracket() {
    return bracket;
  }

  void updateMatch(Match match) {
    for (var i = 0; i < bracket.length; i++) {
      for (var j = 0; j < bracket[i].length; j++) {
        if (bracket[i][j].id == match.id) {
          bracket[i][j] = match;
          return;
        }
      }
    }
  }
}
