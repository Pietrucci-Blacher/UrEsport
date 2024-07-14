import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Websocket _websocket;

  DashboardBloc(this._websocket) : super(DashboardInitial()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<DisconnectWebSocket>(_onDisconnectWebSocket);
    on<WebSocketMessageReceived>(_onWebSocketMessageReceived);
    on<UpdateDashboardStats>(_onUpdateDashboardStats);
    on<AddLogEntry>(_onAddLogEntry);
    on<FetchAllUsers>(_onFetchAllUsers); // Ajout de cette ligne
  }

  Future<void> _onFetchAllUsers(
      FetchAllUsers event, Emitter<DashboardState> emit) async {
    try {
      List<User> users = await fetchUsersFromApiOrDatabase();
      if (state is DashboardLoaded) {
        final currentState = state as DashboardLoaded;
        emit(currentState.copyWith(users: users));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<List<User>> fetchUsersFromApiOrDatabase() async {
    await Future.delayed(const Duration(seconds: 2)); // Correction ici
    return [
      User(
          id: 1,
          username: 'user1',
          firstname: 'First',
          lastname: 'User',
          email: 'user1@example.com',
          roles: ['user']),
    ];
  }

  Future<void> _onConnectWebSocket(
    ConnectWebSocket event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      emit(const DashboardLoaded(
        message: 'Connected',
        activeUsers: 0,
        activeTournaments: 0,
        totalGames: 0,
        recentLogs: [],
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onDisconnectWebSocket(
    DisconnectWebSocket event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(const DashboardLoaded(
        message: 'Disconnected',
        activeUsers: 0,
        activeTournaments: 0,
        totalGames: 0,
        recentLogs: [],
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  void _onWebSocketMessageReceived(
    WebSocketMessageReceived event,
    Emitter<DashboardState> emit,
  ) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(message: event.message));
    }
  }

  void _onUpdateDashboardStats(
    UpdateDashboardStats event,
    Emitter<DashboardState> emit,
  ) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(
        activeUsers: event.stats['activeUsers'] ?? currentState.activeUsers,
        activeTournaments:
            event.stats['activeTournaments'] ?? currentState.activeTournaments,
        totalGames: event.stats['totalGames'] ?? currentState.totalGames,
      ));
    }
  }

  void _onAddLogEntry(
    AddLogEntry event,
    Emitter<DashboardState> emit,
  ) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final updatedLogs = List<String>.from(currentState.recentLogs)
        ..add(event.logEntry);
      emit(currentState.copyWith(recentLogs: updatedLogs));
    }
  }
}
