import 'package:equatable/equatable.dart';
import 'package:uresport/core/models/tournament.dart';

abstract class TournamentEvent extends Equatable {
  const TournamentEvent();

  @override
  List<Object?> get props => [];
}

class LoadTournaments extends TournamentEvent {
  final int? limit;
  final int? page;
  final int? ownerId;

  const LoadTournaments({this.limit, this.page, this.ownerId});

  @override
  List<Object?> get props => [limit, page, ownerId];
}

class TournamentAdded extends TournamentEvent {
  final Tournament newTournament;

  const TournamentAdded(this.newTournament);

  @override
  List<Object?> get props => [newTournament];
}
