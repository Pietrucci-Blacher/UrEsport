import 'package:equatable/equatable.dart';
import 'package:uresport/core/models/user.dart';

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
  final List<User> users;

  const DashboardLoaded({
    required this.message,
    this.activeUsers = 0,
    this.activeTournaments = 0,
    this.totalGames = 0,
    this.recentLogs = const [],
    this.users = const [],
  });

  @override
  List<Object> get props =>
      [message, activeUsers, activeTournaments, totalGames, recentLogs, users];

  DashboardLoaded copyWith({
    String? message,
    int? activeUsers,
    int? activeTournaments,
    int? totalGames,
    List<String>? recentLogs,
    List<User>? users,
  }) {
    return DashboardLoaded(
      message: message ?? this.message,
      activeUsers: activeUsers ?? this.activeUsers,
      activeTournaments: activeTournaments ?? this.activeTournaments,
      totalGames: totalGames ?? this.totalGames,
      recentLogs: recentLogs ?? this.recentLogs,
      users: users ?? this.users,
    );
  }
}

class DashboardError extends DashboardState {
  final String error;

  const DashboardError(this.error);

  @override
  List<Object> get props => [error];
}
