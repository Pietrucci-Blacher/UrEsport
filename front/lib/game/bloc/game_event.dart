import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class LoadGames extends GameEvent {}

class FilterGames extends GameEvent {
  final List<String> tags;

  const FilterGames(this.tags);

  @override
  List<Object?> get props => [tags];
}
