import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class LoadGames extends GameEvent {
  @override
  List<Object> get props => [];
}
