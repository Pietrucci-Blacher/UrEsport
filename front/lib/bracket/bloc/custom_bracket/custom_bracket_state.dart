import 'package:equatable/equatable.dart';
import 'package:uresport/bracket/models/team.dart';

abstract class CustomBracketState extends Equatable {
  const CustomBracketState();

  @override
  List<Object> get props => [];
}

class CustomBracketInitial extends CustomBracketState {}

class CustomBracketLoading extends CustomBracketState {}

class CustomBracketLoaded extends CustomBracketState {
  final List<List<Team>> teams;
  final List<String> roundNames;

  const CustomBracketLoaded(this.teams, this.roundNames);

  @override
  List<Object> get props => [teams, roundNames];

  get poules => null;
}

class CustomBracketError extends CustomBracketState {
  final String message;

  const CustomBracketError(this.message);

  @override
  List<Object> get props => [message];
}
