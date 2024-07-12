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
        final matches =
            await matchService.fetchMatches(tournamentId: event.tournamentId);
        if (matches.isEmpty) {
          emit(const BracketError("No matches found"));
          return;
        }
        emit(BracketLoaded(matches, roundNames));
      } catch (e) {
        emit(const BracketError("Failed to load custom brackets"));
      }
    });
  }

  List<String> _initializeRoundNames() {
    return ["8ème", "Quart de final", "Demi-final", "Final"];
  }
}
