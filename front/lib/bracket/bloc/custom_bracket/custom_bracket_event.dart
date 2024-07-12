import 'package:equatable/equatable.dart';

abstract class BracketEvent extends Equatable {
  const BracketEvent();

  @override
  List<Object?> get props => [];
}

class LoadBracket extends BracketEvent {
  final int? limit;
  final int tournamentId;

  const LoadBracket({this.limit, required this.tournamentId});

  @override
  List<Object?> get props => [limit, tournamentId];
}

class WebsocketBracket extends BracketEvent {}

class BracketWebsocket extends BracketEvent {}
