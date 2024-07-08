import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class ConnectWebSocket extends DashboardEvent {}

class DisconnectWebSocket extends DashboardEvent {}

class WebSocketMessageReceived extends DashboardEvent {
  final String message;

  const WebSocketMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}
