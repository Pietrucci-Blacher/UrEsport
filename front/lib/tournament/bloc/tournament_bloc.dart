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

    on<TournamentAdded>((event, emit) async {
      if (state is TournamentLoadSuccess) {
        final currentTournaments = (state as TournamentLoadSuccess).tournaments;
        emit(TournamentLoadSuccess(
          tournaments: [event.newTournament, ...currentTournaments],
        ));
      }
    });
  }
}
