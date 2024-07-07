import 'package:equatable/equatable.dart';

abstract class BracketEvent extends Equatable {
  const BracketEvent();

  @override
  List<Object?> get props => [];
}

class LoadBracket extends BracketEvent {
  final int? limit;

  const LoadBracket({this.limit});

  @override
  List<Object?> get props => [limit];
}

class BracketWebsocket extends BracketEvent {}
