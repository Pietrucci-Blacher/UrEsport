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
        final games = await gameService.fetchGames(limit: event.limit);
        emit(GameLoaded(games));
      } catch (error) {
        emit(GameError(error.toString()));
      }
    });

    on<FilterGames>((event, emit) async {
      emit(GameLoading());
      try {
        final games = await gameService.fetchGames();
        final filteredGames = games.where((game) {
          return event.tags.any((tag) => game.tags.contains(tag));
        }).toList();
        emit(GameLoaded(filteredGames));
      } catch (error) {
        emit(GameError(error.toString()));
      }
    });
  }
}
