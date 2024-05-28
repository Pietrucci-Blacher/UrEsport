import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/tournament/bloc/tournament_event.dart';
import 'package:uresport/tournament/bloc/tournament_state.dart';

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  final ITournament tournamentService;

  TournamentBloc(this.tournamentService) : super(TournamentInitial()) {
    on<LoadTournaments>((event, emit) async {
      emit(TournamentLoadInProgress());
      try {
        final tournaments = await tournamentService.fetchTournaments(event.limit, event.page);
        emit(TournamentLoadSuccess(tournaments: tournaments));
      } catch (_) {
        emit(TournamentLoadFailure());
      }
    });
  }
}
