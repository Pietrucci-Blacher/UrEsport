import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/game/bloc/game_event.dart';
import 'package:uresport/game/bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final IGameService gameService;

  GameBloc(this.gameService) : super(GameInitial()) {
    on<LoadGames>((event, emit) async {
      emit(GameLoading());
      try {
        final games = await gameService.fetchGames();
        emit(GameLoaded(games));
      } catch (error) {
        emit(GameError(error.toString()));
      }
    });
  }
}
