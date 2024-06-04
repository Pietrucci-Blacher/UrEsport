import 'package:equatable/equatable.dart';
import 'package:uresport/core/models/game.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameLoaded extends GameState {
  final List<Game> games;

  const GamesLoaded(this.games);

  @override
  List<Object> get props => [games];
}

class GameError extends GameState {}
