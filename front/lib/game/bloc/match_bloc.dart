import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/services/match_service.dart';
import 'package:uresport/core/models/match.dart';
import 'package:uresport/match/bloc/match_event.dart';
import 'package:uresport/match/bloc/match_state.dart';
import 'package:uresport/core/websocket/websocket.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final IMatchService matchService;
  final Websocket ws = Websocket.getInstance();

  MatchBloc(this.matchService) : super(MatchInitial()) {
    on<LoadMatches>((event, emit) async {
      emit(MatchLoading());
      try {
        final matches = await matchService.fetchMatches(limit: event.limit);
        emit(MatchLoaded(matches));
      } catch (error) {
        emit(MatchError(error.toString()));
      }
    });

    on<MatchWebsocket>((event, emit) async {
      ws.on('match:update', (socket, data) {
        print('Match updated');
        final match = Match.fromJson(data);
        emit(MatchUpdated(match));
      });

      ws.on('error', (socket, message) {
        emit(MatchError(message));
      });
    });
  }
}
