import 'package:equatable/equatable.dart';
import 'package:uresport/core/models/tournament.dart';

abstract class TournamentState extends Equatable {
  const TournamentState();

  @override
  List<Object> get props => [];
}

class TournamentInitial extends TournamentState {}

class TournamentLoadInProgress extends TournamentState {}

class TournamentLoadSuccess extends TournamentState {
  final List<Tournament> tournaments;

  const TournamentLoadSuccess({required this.tournaments});

  @override
  List<Object> get props => [tournaments];
}

class TournamentLoadFailure extends TournamentState {}
