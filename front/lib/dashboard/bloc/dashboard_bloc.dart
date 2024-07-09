import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Websocket _ws;

  DashboardBloc(this._ws) : super(DashboardInitial()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<DisconnectWebSocket>(_onDisconnectWebSocket);
    on<WebSocketMessageReceived>(_onWebSocketMessageReceived);
    on<UpdateDashboardStats>(_onUpdateDashboardStats);
    on<AddLogEntry>(_onAddLogEntry);
  }

  void _onConnectWebSocket(
      ConnectWebSocket event, Emitter<DashboardState> emit) {
    emit(DashboardLoading());
    _ws.on('connected', (socket, message) {
      add(const WebSocketMessageReceived('Connected to WebSocket'));
    });

    _ws.on('error', (socket, message) {
      emit(DashboardError('Error: $message'));
    });

    _ws.on('pong', (socket, message) {
      add(WebSocketMessageReceived('Pong received: $message'));
    });

    _ws.on('stats_update', (socket, message) {
      add(UpdateDashboardStats(message as Map<String, dynamic>));
    });

    _ws.on('new_log', (socket, message) {
      add(AddLogEntry(message as String));
    });

    _ws.emit('ping', 'Hello from client!');
  }

  void _onDisconnectWebSocket(
      DisconnectWebSocket event, Emitter<DashboardState> emit) {
    emit(DashboardInitial());
  }

  void _onWebSocketMessageReceived(
      WebSocketMessageReceived event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      emit((state as DashboardLoaded).copyWith(message: event.message));
    } else {
      emit(DashboardLoaded(message: event.message));
    }
  }

  void _onUpdateDashboardStats(
      UpdateDashboardStats event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      emit((state as DashboardLoaded).copyWith(
        activeUsers: event.stats['activeUsers'] as int?,
        activeTournaments: event.stats['activeTournaments'] as int?,
        totalGames: event.stats['totalGames'] as int?,
      ));
    } else {
      emit(DashboardLoaded(
        message: 'Stats updated',
        activeUsers: event.stats['activeUsers'] as int? ?? 0,
        activeTournaments: event.stats['activeTournaments'] as int? ?? 0,
        totalGames: event.stats['totalGames'] as int? ?? 0,
      ));
    }
  }

  void _onAddLogEntry(AddLogEntry event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final updatedLogs = List<String>.from(currentState.recentLogs)
        ..insert(0, event.logEntry);
      if (updatedLogs.length > 10) updatedLogs.removeLast();
      emit(currentState.copyWith(recentLogs: updatedLogs));
    } else {
      emit(DashboardLoaded(
        message: 'New log entry',
        recentLogs: [event.logEntry],
      ));
    }
  }
}
