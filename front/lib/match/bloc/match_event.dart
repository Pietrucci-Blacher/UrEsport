import 'package:equatable/equatable.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object?> get props => [];
}

class LoadMatches extends MatchEvent {
  final int? limit;

  const LoadMatches({this.limit});

  @override
  List<Object?> get props => [limit];
}

class MatchWebsocket extends MatchEvent {}
