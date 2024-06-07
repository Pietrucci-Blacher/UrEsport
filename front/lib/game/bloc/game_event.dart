import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class LoadGames extends GameEvent {}
