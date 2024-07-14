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

class UpdateDashboardStats extends DashboardEvent {
  final Map<String, dynamic> stats;

  const UpdateDashboardStats(this.stats);

  @override
  List<Object> get props => [stats];
}

class AddLogEntry extends DashboardEvent {
  final String logEntry;

  const AddLogEntry(this.logEntry);

  @override
  List<Object> get props => [logEntry];
}

class FetchAllUsers extends DashboardEvent {}

class FetchTournaments extends DashboardEvent {}

class FetchGames extends DashboardEvent {}

