import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Websocket _ws;
  final IAuthService _authService;

  DashboardBloc(this._ws, this._authService) : super(DashboardInitial()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<DisconnectWebSocket>(_onDisconnectWebSocket);
    on<WebSocketMessageReceived>(_onWebSocketMessageReceived);
    on<LoadUsers>(_onLoadUsers);
    on<UpdateUsers>(_onUpdateUsers);
    on<FetchAllUsers>(_onFetchAllUsers);
  }

  Future<void> _onConnectWebSocket(
    ConnectWebSocket event,
    Emitter<DashboardState> emit,
  ) async {
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

    _ws.emit('ping', 'Hello from client!');
    add(LoadUsers());
  }

  Future<void> _onDisconnectWebSocket(
    DisconnectWebSocket event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      _ws.disconnect();
      emit(const DashboardLoaded(
        message: 'Disconnected',
        activeUsers: 0,
        activeTournaments: 0,
        totalGames: 0,
        recentLogs: [],
        users: [],
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

  Future<void> _onLoadUsers(
      LoadUsers event, Emitter<DashboardState> emit) async {
    try {
      final users = await _authService.fetchUsers();
      add(UpdateUsers(users));
    } catch (e) {
      emit(DashboardError('Failed to load users: $e'));
    }
  }

  void _onUpdateUsers(UpdateUsers event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      emit((state as DashboardLoaded).copyWith(users: event.users));
    } else {
      emit(DashboardLoaded(message: 'Users loaded', users: event.users));
    }
  }

  Future<void> _onFetchAllUsers(
      FetchAllUsers event, Emitter<DashboardState> emit) async {
    try {
      final users = await _authService.fetchAllUsers();
      add(UpdateUsers(users));
    } catch (e) {
      emit(DashboardError('Failed to fetch users: $e'));
    }
  }
}
