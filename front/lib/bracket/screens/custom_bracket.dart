import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_bracket/tournament_bracket.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_bloc.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_event.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_state.dart';
import 'package:uresport/core/models/match.dart';
import 'package:uresport/core/services/bracket_service.dart';
import 'package:uresport/core/services/match_service.dart';
import 'package:uresport/core/websocket/websocket.dart';

class TournamentBracketPage extends StatelessWidget {
  final int tournamentId;

  const TournamentBracketPage({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BracketBloc(MatchService(Dio()))
        ..add(LoadBracket(tournamentId: tournamentId)),
      child: Scaffold(
        body: BlocBuilder<BracketBloc, BracketState>(
          builder: (context, state) {
            if (state is BracketLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BracketLoaded) {
              BracketService bracket = BracketService(state.matches);
              return BracketContent(
                  bracket: bracket,
                  roundNames: state.roundNames,
                  tournamentId: tournamentId);
            } else if (state is BracketUpdate) {
              return const Center(child: Text('Bracket updated'));
            } else if (state is BracketError) {
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
  final BracketService bracket;
  final List<String> roundNames;
  final int tournamentId;

  const BracketContent(
      {required this.bracket,
      required this.roundNames,
      required this.tournamentId,
      super.key});

  @override
  BracketContentState createState() => BracketContentState();
}

class BracketContentState extends State<BracketContent> {
  int selectedLevel = 0;
  final ScrollController _scrollController = ScrollController();
  final Websocket ws = Websocket.getInstance();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void websocket() {
    ws.on('match:update', (socket, data) async {
      final match = Match.fromJson(data);
      widget.bracket.updateMatch(match);
    });

    ws.emit('tournament:add-to-room', {
      'tournament_id': widget.tournamentId,
    });
  }

  @override
  Widget build(BuildContext context) {
    websocket();
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.bracket.getBracket().length,
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
                      widget.roundNames[index +
                          (widget.roundNames.length -
                              widget.bracket.getBracket().length)],
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
              child: TBracket<Match>(
                space: _getSpace(selectedLevel),
                separation: _getSeparation(selectedLevel),
                stageWidth: 200,
                onSameTeam: (match1, match2) {
                  if (match1 != null && match2 != null) {
                    return match1.id == match2.id;
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
                      widget.roundNames[index +
                          (widget.roundNames.length -
                              widget.bracket.getBracket().length)],
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
                containt: widget.bracket.getBracket(),
                teamNameBuilder: (Match m) {
                  var team1 = m.team1?.name ?? '';
                  var team2 = m.team2?.name ?? '';

                  if (team1.isEmpty) {
                    team1 = 'waiting';
                  }
                  if (team2.isEmpty) {
                    team2 = 'waiting';
                  }

                  return BracketText(
                      text: '$team1 (${m.score1})\n$team2 (${m.score2})',
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ));
                },
                onContainerTapDown:
                    (Match? model, TapDownDetails tapDownDetails) {
                  if (model == null) {
                    debugPrint(null);
                  } else {
                    if (kDebugMode) {
                      debugPrint(model.id as String?);
                    }
                  }
                },
                onLineIconPress: (match1, match2, tapDownDetails) {
                  if (match1 != null && match2 != null) {
                    debugPrint("${match1.id} and ${match2.id}");
                  } else {
                    debugPrint(null);
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
    int numMatches = widget.bracket.getBracket().length ~/ 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numMatches, (i) => const Divider(thickness: 2)),
    );
  }

  void _scrollToLevel(int index) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double itemWidth = 250;
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
