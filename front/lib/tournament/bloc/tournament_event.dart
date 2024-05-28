import 'package:equatable/equatable.dart';

abstract class TournamentEvent extends Equatable {
  const TournamentEvent();

  @override
  List<Object> get props => [];
}

class LoadTournaments extends TournamentEvent {
  final int limit;
  final int page;

  const LoadTournaments({required this.limit, required this.page});

  @override
  List<Object> get props => [limit, page];
}
