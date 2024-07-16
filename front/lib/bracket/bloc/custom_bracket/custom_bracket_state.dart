import 'package:equatable/equatable.dart';
// import 'package:uresport/bracket/models/team.dart';
import 'package:uresport/core/models/match.dart';

abstract class BracketState extends Equatable {
  const BracketState();

  @override
  List<Object> get props => [];
}

class BracketInitial extends BracketState {}

class BracketLoading extends BracketState {}

class BracketLoaded extends BracketState {
  final List<Match> matches;
  final List<String> roundNames;

  const BracketLoaded(this.matches, this.roundNames);

  @override
  List<Object> get props => [matches, roundNames];

  get poules => null;
}

class BracketUpdate extends BracketState {
  final Match match;

  const BracketUpdate(this.match);

  @override
  List<Object> get props => [match];
}

class BracketError extends BracketState {
  final String message;

  const BracketError(this.message);

  @override
  List<Object> get props => [message];
}
