import 'package:equatable/equatable.dart';

abstract class TournamentEvent extends Equatable {
  const TournamentEvent();

  @override
  List<Object> get props => [];
}

class LoadTournaments extends TournamentEvent {
  final int? limit;
  final int? page;
  final int? ownerId;

  const LoadTournaments({this.limit, this.page, this.ownerId});
}

class AddTournament extends TournamentEvent {
  final Map<String, dynamic> tournamentData;

  const AddTournament(this.tournamentData);
}
