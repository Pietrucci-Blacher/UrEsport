import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/tournament/bloc/tournament_event.dart';
import 'package:uresport/tournament/bloc/tournament_state.dart';

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  final ITournamentService tournamentService;

  TournamentBloc(this.tournamentService) : super(TournamentInitial()) {
    on<LoadTournaments>((event, emit) async {
      emit(TournamentLoadInProgress());
      try {
        final tournaments = await tournamentService.fetchTournaments(
            limit: event.limit, page: event.page, ownerId: event.ownerId);
        emit(TournamentLoadSuccess(tournaments: tournaments));
      } catch (e) {
        debugPrint('Error loading tournaments: $e');
        emit(TournamentLoadFailure());
      }
    });

    on<AddTournament>((event, emit) async {
      try {
        await tournamentService.createTournament(event.tournamentData);
        emit(TournamentLoadSuccess(
            tournaments: tournamentService.tournamentsNotifier.value));
      } catch (e) {
        debugPrint('Error adding tournament: $e');
        emit(TournamentLoadFailure());
      }
    });
  }
}
