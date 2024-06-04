import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/services/game_service.dart';
import 'package:uresport/blocs/game_event.dart';
import 'package:uresport/blocs/game_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final IGameService gameService;

  GamesBloc(this.gameService) : super(GamesInitial()) {
    on<LoadGames>((event, emit) async {
      emit(GamesLoading());
      try {
        final games = await gameService.fetchGames();
        emit(GamesLoaded(games));
      } catch (_) {
        emit(GamesError());
      }
    });
  }
}
