import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String message;
  final int activeUsers;
  final int activeTournaments;
  final int totalGames;
  final List<String> recentLogs;

  const DashboardLoaded({
    required this.message,
    this.activeUsers = 0,
    this.activeTournaments = 0,
    this.totalGames = 0,
    this.recentLogs = const [],
  });

  @override
  List<Object> get props =>
      [message, activeUsers, activeTournaments, totalGames, recentLogs];

  DashboardLoaded copyWith({
    String? message,
    int? activeUsers,
    int? activeTournaments,
    int? totalGames,
    List<String>? recentLogs,
  }) {
    return DashboardLoaded(
      message: message ?? this.message,
      activeUsers: activeUsers ?? this.activeUsers,
      activeTournaments: activeTournaments ?? this.activeTournaments,
      totalGames: totalGames ?? this.totalGames,
      recentLogs: recentLogs ?? this.recentLogs,
    );
  }
}

class DashboardError extends DashboardState {
  final String error;

  const DashboardError(this.error);

  @override
  List<Object> get props => [error];
}
