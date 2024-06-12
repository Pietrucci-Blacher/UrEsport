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

  final all = [
    List.generate(
        8, (index) => Team(name: 'team1 ${index + 1}', age: index + 1)),
    List.generate(
        4, (index) => Team(name: 'team2 ${(index * 2) + 1}', age: index + 1)),
    List.generate(
        2, (index) => Team(name: 'team3 ${index + 1}', age: index + 1)),
    List.generate(
        1, (index) => Team(name: 'team4 ${index + 1}', age: index + 1)),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tournament Bracket"),
      ),
      body: Column(
        children: [
          // Header des niveaux
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: all.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedLevel = index;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToLevel(index);
                  });
                },
                child: Container(
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
                  child: Text("Level ${index + 1}"),
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
                        'Round ${index + 1}',
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
                    text: t.name,
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

  List<List<Team>> _getFilteredTeams() {
    List<List<Team>> filteredTeams = [];
    for (int i = 0; i <= selectedLevel; i++) {
      if (i < all.length) {
        filteredTeams.add(all[i]);
      }
    }
    return filteredTeams;
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
    required this.age,
  });

  final int age;
  final String name;
}

