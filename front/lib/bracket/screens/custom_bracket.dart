import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_bracket/tournament_bracket.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_bloc.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_event.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_state.dart';
import 'package:uresport/bracket/models/team.dart';

class TournamentBracketPage extends StatelessWidget {
  const TournamentBracketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomBracketBloc()..add(LoadCustomBracket()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tournament Bracket'),
        ),
        body: BlocBuilder<CustomBracketBloc, CustomBracketState>(
          builder: (context, state) {
            if (state is CustomBracketLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CustomBracketLoaded) {
              return BracketContent(
                  teams: state.teams, roundNames: state.roundNames);
            } else if (state is CustomBracketError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}

class BracketContent extends StatefulWidget {
  final List<List<Team>> teams;
  final List<String> roundNames;

  const BracketContent(
      {required this.teams, required this.roundNames, super.key});

  @override
  BracketContentState createState() => BracketContentState();
}

class BracketContentState extends State<BracketContent> {
  int selectedLevel = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130, // Ajustez la hauteur selon vos besoins
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.roundNames.length,
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
                      widget.roundNames[index],
                      style: TextStyle(
                        fontWeight: selectedLevel == index
                            ? FontWeight.bold
                            : FontWeight.normal,
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
                      widget.roundNames[index],
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
                containt: widget.teams,
                teamNameBuilder: (Team t) => BracketText(
                  text: '${t.name} (${t.score})',
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onContainerTapDown:
                    (Team? model, TapDownDetails tapDownDetails) {
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
    );
  }

  Widget _buildRoundButton(int index) {
    int numMatches = widget.teams[index].length ~/ 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numMatches, (i) => const Divider(thickness: 2)),
    );
  }

  void _scrollToLevel(int index) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double itemWidth = 250; // La largeur de chaque stage
    final double position =
        index * itemWidth - (screenWidth / 2) + (itemWidth / 2);

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