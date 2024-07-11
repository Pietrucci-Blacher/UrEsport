import 'package:equatable/equatable.dart';
import 'package:uresport/core/models/user.dart';

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

class LoadUsers extends DashboardEvent {}

class UpdateUsers extends DashboardEvent {
  final List<User> users;

  const UpdateUsers(this.users);

  @override
  List<Object> get props => [users];
}

class FetchAllUsers extends DashboardEvent {}
