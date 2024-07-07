import 'package:flutter_bloc/flutter_bloc.dart';
import 'events.dart';
import 'states.dart';
import 'package:uresport/bracket/models/poule.dart';
import 'package:uresport/bracket/models/team.dart';

class PouleBloc extends Bloc<PouleEvent, PouleState> {
  PouleBloc() : super(PouleInitial()) {
    on<LoadPoules>(_onLoadPoules);
  }

  void _onLoadPoules(
    LoadPoules event,
    Emitter<PouleState> emit,
  ) async {
    emit(PouleLoading());
    try {
      List<Poule> poules = _initializePoules();
      emit(PouleLoaded(poules));
    } catch (e) {
      emit(const PouleError("Failed to load poules"));
    }
  }

  List<Poule> _initializePoules() {
    return [
      Poule(name: 'Poule A', teams: [
        Team(name: 'Team 1', score: '3'),
        Team(name: 'Team 2', score: '1'),
        Team(name: 'Team 3', score: '2'),
        Team(name: 'Team 4', score: '0'),
        Team(name: 'Team 9', score: '1'),
      ]),
      Poule(name: 'Poule B', teams: [
        Team(name: 'Team 5', score: '2'),
        Team(name: 'Team 6', score: '3'),
        Team(name: 'Team 7', score: '0'),
        Team(name: 'Team 8', score: '1'),
        Team(name: 'Team 10', score: '1'),
      ]),
      Poule(name: 'Poule C', teams: [
        Team(name: 'Team 11', score: '4'),
        Team(name: 'Team 12', score: '2'),
        Team(name: 'Team 13', score: '1'),
        Team(name: 'Team 14', score: '3'),
        Team(name: 'Team 15', score: '0'),
      ]),
      Poule(name: 'Poule D', teams: [
        Team(name: 'Team 16', score: '1'),
        Team(name: 'Team 17', score: '2'),
        Team(name: 'Team 18', score: '3'),
        Team(name: 'Team 19', score: '4'),
        Team(name: 'Team 20', score: '0'),
      ]),
      Poule(name: 'Poule E', teams: [
        Team(name: 'Team 21', score: '3'),
        Team(name: 'Team 22', score: '1'),
        Team(name: 'Team 23', score: '2'),
        Team(name: 'Team 24', score: '4'),
        Team(name: 'Team 25', score: '0'),
      ]),
    ];
  }
}
