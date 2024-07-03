import 'package:equatable/equatable.dart';
import 'package:uresport/core/models/match.dart';

abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object?> get props => [];
}

class MatchInitial extends MatchState {}

class MatchLoading extends MatchState {}

class MatchLoaded extends MatchState {
  final List<Match> matches;

  const MatchLoaded(this.matches);

  @override
  List<Object?> get props => [matches];
}

class MatchUpdated extends MatchState {
  final Match match;

  const MatchUpdated(this.match);

  @override
  List<Object?> get props => [match];
}

class MatchError extends MatchState {
  final String message;

  const MatchError(this.message);

  @override
  List<Object?> get props => [message];
}
