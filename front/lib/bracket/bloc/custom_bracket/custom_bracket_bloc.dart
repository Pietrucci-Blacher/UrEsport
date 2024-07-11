import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_event.dart';
import 'package:uresport/bracket/bloc/custom_bracket/custom_bracket_state.dart';
import 'package:uresport/bracket/models/team.dart';

class CustomBracketBloc extends Bloc<CustomBracketEvent, CustomBracketState> {
  CustomBracketBloc() : super(CustomBracketInitial()) {
    on<LoadCustomBracket>(_onLoadCustomBracket);
  }

  void _onLoadCustomBracket(
    LoadCustomBracket event,
    Emitter<CustomBracketState> emit,
  ) async {
    emit(CustomBracketLoading());
    try {
      List<List<Team>> teams = _initializeTeams();
      List<String> roundNames = _initializeRoundNames();
      emit(CustomBracketLoaded(teams, roundNames));
    } catch (e) {
      emit(const CustomBracketError("Failed to load custom brackets"));
    }
  }

  List<List<Team>> _initializeTeams() {
    List<List<Team>> all = [];

    // Ajout des équipes qualifiées des poules
    all.add([
      Team(name: 'Team 1', score: '3'),
      Team(name: 'Team 6', score: '3'),
      Team(name: 'Team 3', score: '2'),
      Team(name: 'Team 5', score: '2'),
      Team(name: 'Team 2', score: '1'),
      Team(name: 'Team 8', score: '1'),
      Team(name: 'Team 9', score: '1'),
      Team(name: 'Team 10', score: '1'),
    ]);

    // Initialize other rounds as empty lists
    for (int i = 0; i < 3; i++) {
      all.add([]);
    }

    _initializeRounds(all);

    return all;
  }

  List<String> _initializeRoundNames() {
    return ["8ème", "Quart de final", "Demi-final", "Final"];
  }

  void _initializeRounds(List<List<Team>> all) {
    // Determine winners for round 1
    List<Team> round1Winners = _getWinners(all[0]);
    all[1] = round1Winners;

    // Determine winners for round 2
    if (round1Winners.length > 1) {
      List<Team> round2Winners = _getWinners(round1Winners);
      all[2] = round2Winners;

      // Determine winner for round 3
      if (round2Winners.length > 1) {
        List<Team> finalWinners = _getWinners(round2Winners);
        if (finalWinners.isNotEmpty) {
          all[3] = [finalWinners.first]; // Only add the final winner
        }
      }
    }
  }

  List<Team> _getWinners(List<Team> teams) {
    List<Team> winners = [];
    for (int i = 0; i < teams.length; i += 2) {
      if (i + 1 < teams.length) {
        winners.add(
          int.parse(teams[i].score) > int.parse(teams[i + 1].score)
              ? teams[i]
              : teams[i + 1],
        );
      }
    }
    return winners;
  }
}
