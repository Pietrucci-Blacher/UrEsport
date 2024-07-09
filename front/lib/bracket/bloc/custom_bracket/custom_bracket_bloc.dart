import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_event.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_state.dart';
import 'package:uresport/core/services/match_service.dart';
import 'package:uresport/core/models/match.dart';
import 'package:uresport/core/websocket/websocket.dart';

class BracketBloc extends Bloc<BracketEvent, BracketState> {
  final IMatchService matchService;
  final Websocket ws = Websocket.getInstance();

  BracketBloc(this.matchService) : super(BracketInitial()) {
    on<LoadBracket>((event, emit) async {
      emit(BracketLoading());
      try {
        List<String> roundNames = _initializeRoundNames();
        final matches = await matchService.fetchMatches();
        emit(BracketLoaded(matches, roundNames));
      } catch (e) {
        emit(const BracketError("Failed to load custom brackets"));
      }
    });

    on<WebsocketBracket>((event, emit) async {
      ws.on('match:update', (socket, data) {
        final match = Match.fromJson(data);
        print('Match updated: ${match.toJson()}');
        emit(BracketUpdate(match));
      });

      ws.on('error', (socket, message) {
        emit(BracketError(message));
      });

      ws.on('info', (socket, message) {
        print('Info: $message');
      });

      ws.emit('tournament:add-to-room', {
        'tournament_id': 1,
      });
    });
  }

  List<String> _initializeRoundNames() {
    return ["8ème", "Quart de final", "Demi-final", "Final"];
  }

  // void _initializeRounds(List<List<Team>> all) {
  //   // Determine winners for round 1
  //   List<Team> round1Winners = _getWinners(all[0]);
  //   all[1] = round1Winners;

  //   // Determine winners for round 2
  //   if (round1Winners.length > 1) {
  //     List<Team> round2Winners = _getWinners(round1Winners);
  //     all[2] = round2Winners;

  //     // Determine winner for round 3
  //     if (round2Winners.length > 1) {
  //       List<Team> finalWinners = _getWinners(round2Winners);
  //       if (finalWinners.isNotEmpty) {
  //         all[3] = [finalWinners.first]; // Only add the final winner
  //       }
  //     }
  //   }
  // }

  // List<Team> _getWinners(List<Team> teams) {
  //   List<Team> winners = [];
  //   for (int i = 0; i < teams.length; i += 2) {
  //     if (i + 1 < teams.length) {
  //       winners.add(
  //         int.parse(teams[i].score) > int.parse(teams[i + 1].score)
  //             ? teams[i]
  //             : teams[i + 1],
  //       );
  //     }
  //   }
  //   return winners;
  // }
}
