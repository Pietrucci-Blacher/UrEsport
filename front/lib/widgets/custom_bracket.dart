import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tournament_bracket/tournament_bracket.dart';

class TournamentBracketPage extends StatefulWidget {
  @override
  _TournamentBracketPageState createState() => _TournamentBracketPageState();
}

class _TournamentBracketPageState extends State<TournamentBracketPage> {
  int selectedLevel = 0;
  final ScrollController _scrollController = ScrollController();

  final List<List<Team>> all = [];
  final List<String> roundNames = [];

  @override
  void initState() {
    super.initState();

    // Ajout des noms de rounds
    addRound("8ème");
    addRound("Quart de final");
    addRound("Demi-final");
    addRound("Final");

    // Ajout des équipes qualifiées des poules
    addTeams([
      Team(name: 'Team 1', score: '3'),
      Team(name: 'Team 6', score: '3'),
      Team(name: 'Team 3', score: '2'),
      Team(name: 'Team 5', score: '2'),
      Team(name: 'Team 2', score: '1'),
      Team(name: 'Team 8', score: '1'),
      Team(name: 'Team 9', score: '1'),
      Team(name: 'Team 10', score: '1'),
    ], 0);

    _initializeRounds();
  }

  void addTeams(List<Team> teams, int roundIndex) {
    if (roundIndex >= all.length) {
      // Create new rounds if necessary
      for (int i = all.length; i <= roundIndex; i++) {
        all.add([]);
        roundNames.add("Round ${i + 1}");
      }
    }
    all[roundIndex].addAll(teams);
    setState(() {});
  }

  void addRound(String roundName) {
    roundNames.add(roundName);
    all.add([]);
    setState(() {});
  }

  void _initializeRounds() {
    // Determine winners for round 1
    List<Team> round1Winners = _getWinners(all[0]);
    all[1] = round1Winners;

    // Determine winners for round 2
    if (round1Winners.length > 1) {
      List<Team> round2Winners = _getWinners(round1Winners);
      all[2] = round2Winners;

      // Determine winner for round 3
      if (round2Winners.length > 1) {
        List<Team> finalWinners = _getWinners(round2Winners);
        if (finalWinners.isNotEmpty) {
          all[3] = [finalWinners.first]; // Only add the final winner
        }
      }
    }
  }

  List<Team> _getWinners(List<Team> teams) {
    List<Team> winners = [];
    for (int i = 0; i < teams.length; i += 2) {
      if (i + 1 < teams.length) {
        winners.add(
          int.parse(teams[i].score) > int.parse(teams[i + 1].score)
              ? teams[i]
              : teams[i + 1],
        );
      }
    }
    return winners;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Bracket'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Header des niveaux
          SizedBox(
            height: 130, // Ajustez la hauteur selon vos besoins
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: roundNames.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedLevel = index;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToLevel(index);
                  });
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        roundNames[index],
                        style: TextStyle(
                          fontWeight: selectedLevel == index ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        alignment: Alignment.center,
                        width: 100,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: selectedLevel == index
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                        child: _buildRoundButton(index),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Center(
                child: TBracket<Team>(
                  space: _getSpace(selectedLevel),
                  separation: _getSeparation(selectedLevel),
                  stageWidth: 200,
                  onSameTeam: (team1, team2) {
                    if (team1 != null && team2 != null) {
                      return team1.name == team2.name;
                    }
                    return false;
                  },
                  hadderBuilder: (context, index, count) => Transform.scale(
                    scale: selectedLevel == index ? 1.5 : 1.0,
                    child: Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      child: Text(
                        roundNames[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  connectorColor: const Color.fromARGB(144, 244, 67, 54),
                  winnerConnectorColor: Colors.green,
                  teamContainerDecoration: BracketBoxDecroction(
                    borderRadious: 15,
                    color: Colors.black,
                  ),
                  stageIndicatorBoxDecroction: BracketStageIndicatorBoxDecroction(
                    borderRadious: const Radius.circular(15),
                    primaryColor: const Color.fromARGB(255, 236, 236, 236),
                    secondaryColor: const Color.fromARGB(15, 194, 236, 147),
                  ),
                  containt: all,
                  teamNameBuilder: (Team t) => BracketText(
                    text: '${t.name} (${t.score})',
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onContainerTapDown: (Team? model, TapDownDetails tapDownDetails) {
                    if (model == null) {
                      if (kDebugMode) {
                        print(null);
                      }
                    } else {
                      if (kDebugMode) {
                        print(model.name);
                      }
                    }
                  },
                  onLineIconPress: (team1, team2, tapDownDetails) {
                    if (team1 != null && team2 != null) {
                      if (kDebugMode) {
                        print("${team1.name} and ${team2.name}");
                      }
                    } else {
                      if (kDebugMode) {
                        print(null);
                      }
                    }
                  },
                  context: context,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton(int index) {
    int numMatches = all[index].length ~/ 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numMatches, (i) => const Divider(thickness: 2)),
    );
  }

  void _scrollToLevel(int index) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double itemWidth = 250; // La largeur de chaque stage
    final double position = index * itemWidth - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      position > 0 ? position : 0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  double _getSpace(int level) {
    switch (level) {
      case 0:
        return 200 / 4;
      case 1:
        return 100 / 2;
      case 2:
        return 50 / 1.5;
      default:
        return 50 / 1.2;
    }
  }

  double _getSeparation(int level) {
    switch (level) {
      case 0:
        return 250;
      case 1:
        return 120;
      case 2:
        return 50;
      default:
        return 50;
    }
  }
}

class Team {
  Team({
    required this.name,
    required this.score,
  });

  final String score;
  final String name;
}
