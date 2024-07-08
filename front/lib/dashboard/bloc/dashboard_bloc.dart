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

    _ws.emit('ping', 'Hello from client!');
  }

  void _onDisconnectWebSocket(
      DisconnectWebSocket event, Emitter<DashboardState> emit) {
    emit(DashboardInitial());
  }

  void _onWebSocketMessageReceived(
      WebSocketMessageReceived event, Emitter<DashboardState> emit) {
    emit(DashboardLoaded(event.message));
  }
}
