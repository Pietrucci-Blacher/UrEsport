import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_event.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_state.dart';
import 'package:uresport/core/services/match_service.dart';
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

    // on<WebsocketBracket>((event, emit) {
    //   ws.on('match:update', (socket, data) async {
    //     final match = Match.fromJson(data);
    //     print('Match updated: ${match.toJson()}');
    //     emit(BracketUpdate(match));
    //   });

    //   ws.on('error', (socket, message) {
    //     emit(BracketError(message));
    //   });

    //   ws.on('info', (socket, message) {
    //     print('Info: $message');
    //   });

    //   ws.emit('tournament:add-to-room', {
    //     'tournament_id': 1,
    //   });
    // });
  }

  List<String> _initializeRoundNames() {
    return ["8ème", "Quart de final", "Demi-final", "Final"];
  }
}
