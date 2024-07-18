import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';

import 'package:uresport/core/services/auth_service.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Websocket _websocket;
  final TournamentService _tournamentService;
  final GameService _gameService;
  final AuthService _authService;  // Déclaration du service

  DashboardBloc(this._websocket, this._tournamentService, this._gameService, this._authService)
      : super(DashboardInitial()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<DisconnectWebSocket>(_onDisconnectWebSocket);
    on<WebSocketMessageReceived>(_onWebSocketMessageReceived);
    on<UpdateDashboardStats>(_onUpdateDashboardStats);
    on<AddLogEntry>(_onAddLogEntry);
    on<FetchAllUsers>(_onFetchAllUsers);
    on<FetchTournaments>(_onFetchTournaments);
    on<FetchGames>(_onFetchGames);
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

  void _onAddLogEntry(AddLogEntry event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final updatedLogs = List<String>.from(currentState.recentLogs)
        ..add(event.logEntry);
      emit(currentState.copyWith(recentLogs: updatedLogs));
    }
  }

  Future<void> _onFetchTournaments(
      FetchTournaments event, Emitter<DashboardState> emit) async {
    try {
      List<Tournament> tournaments =
          await _tournamentService.fetchTournaments();
      emit(DashboardLoaded(
        message: 'Tournaments loaded',
        loggedInUsers: 0, // mettez à jour selon vos besoins
        anonymousUsers: 0,
        subscribedUsers: 0,
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
          loggedInUsers: 0,
          anonymousUsers: 0,
          subscribedUsers: 0,
          games: games,
        ));
      }
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
