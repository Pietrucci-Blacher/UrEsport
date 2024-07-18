import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/core/models/log.dart';
import 'package:uresport/core/services/log_service.dart';

import 'package:uresport/core/services/auth_service.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final TournamentService _tournamentService;
  final GameService _gameService;
  final LogService _logService;
  final AuthService _authService;

  DashboardBloc(this._tournamentService, this._gameService, this._authService, this._logService)
      : super(DashboardInitial()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<DisconnectWebSocket>(_onDisconnectWebSocket);
    on<WebSocketMessageReceived>(_onWebSocketMessageReceived);
    on<UpdateDashboardStats>(_onUpdateDashboardStats);
    // on<AddLogEntry>(_onAddLogEntry);
    on<FetchAllUsers>(_onFetchAllUsers);
    on<FetchTournaments>(_onFetchTournaments);
    on<FetchLogs>(_onFetchLogs);
    on<FetchGames>(_onFetchGames);
    on<FetchUserStats>(_onFetchUserStats);
    on<DeleteGameEvent>(_onDeleteGame);
  }

  Future<void> _onFetchAllUsers(FetchAllUsers event, Emitter<DashboardState> emit) async {
    try {
      List<User> users = await _authService.fetchUsers();  // Utilisation du service
      if (state is DashboardLoaded) {
        final currentState = state as DashboardLoaded;
        emit(currentState.copyWith(users: users));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onConnectWebSocket(
      ConnectWebSocket event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      emit(const DashboardLoaded(
        message: 'Connected',
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onDisconnectWebSocket(
      DisconnectWebSocket event, Emitter<DashboardState> emit) async {
    try {
      emit(const DashboardLoaded(
        message: 'Disconnected',
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  void _onWebSocketMessageReceived(
      WebSocketMessageReceived event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(message: event.message));
    }
  }

  void _onUpdateDashboardStats(
      UpdateDashboardStats event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(
        loggedInUsers:
            event.stats['loggedInUsers'] ?? currentState.loggedInUsers,
        anonymousUsers:
            event.stats['anonymousUsers'] ?? currentState.anonymousUsers,
        subscribedUsers:
            event.stats['subscribedUsers'] ?? currentState.subscribedUsers,
      ));
    }
  }

  // void _onAddLogEntry(AddLogEntry event, Emitter<DashboardState> emit) {
  //   if (state is DashboardLoaded) {
  //     final currentState = state as DashboardLoaded;
  //     final updatedLogs = List<String>.from(currentState.recentLogs)
  //       ..add(event.logEntry);
  //     emit(currentState.copyWith(recentLogs: updatedLogs));
  //   }
  // }

  Future<void> _onFetchLogs(
      FetchLogs event, Emitter<DashboardState> emit) async {
    try {
      final List<Log> logs = await _logService.fetchLogs(sort: 'id desc');
      emit(DashboardLoaded(
        message: 'Logs loaded',
        recentLogs: logs, // mettez à jour selon vos besoins
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onFetchTournaments(
      FetchTournaments event, Emitter<DashboardState> emit) async {
    try {
      List<Tournament> tournaments =
          await _tournamentService.fetchTournaments();
      emit(DashboardLoaded(
        message: 'Tournaments loaded',
        tournaments: tournaments,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onFetchGames(
      FetchGames event, Emitter<DashboardState> emit) async {
    try {
      List<Game> games = await _gameService.fetchGames();
      if (state is DashboardLoaded) {
        final currentState = state as DashboardLoaded;
        emit(currentState.copyWith(games: games));
      } else {
        emit(DashboardLoaded(
          message: 'Games loaded',
          games: games,
        ));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onFetchUserStats(
      FetchUserStats event, Emitter<DashboardState> emit) async {
    try {
      final stats = await _authService.fetchUserStats();
      emit(DashboardLoaded(
        message: 'User stats loaded',
        loggedInUsers: stats['loggedInUsers'] ?? 0,
        anonymousUsers: stats['anonymousUsers'] ?? 0,
        subscribedUsers: stats['subscribedUsers'] ?? 0,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onDeleteGame(
      DeleteGameEvent event, Emitter<DashboardState> emit) async {
    try {
      await _gameService.deleteGame(event.gameId);
      add(FetchGames()); // Fetch updated list of games
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
