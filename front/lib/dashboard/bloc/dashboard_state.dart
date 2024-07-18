import 'package:equatable/equatable.dart';
import 'package:uresport/core/models/game.dart';
import 'package:uresport/core/models/tournament.dart';
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
  final int loggedInUsers;
  final int anonymousUsers;
  final int subscribedUsers;
  final List<String> recentLogs;
  final List<User> users;
  final List<Tournament> tournaments;
  final List<Game> games;

  const DashboardLoaded({
    required this.message,
    this.loggedInUsers = 0,
    this.anonymousUsers = 0,
    this.subscribedUsers = 0,
    this.recentLogs = const [],
    this.users = const [],
    this.tournaments = const [],
    this.games = const [],
  });

  @override
  List<Object> get props => [
        message,
        loggedInUsers,
        anonymousUsers,
        subscribedUsers,
        recentLogs,
        users,
        tournaments,
        games
      ];

  DashboardLoaded copyWith({
    String? message,
    int? loggedInUsers,
    int? anonymousUsers,
    int? subscribedUsers,
    List<String>? recentLogs,
    List<User>? users,
    List<Tournament>? tournaments,
    List<Game>? games,
  }) {
    return DashboardLoaded(
      message: message ?? this.message,
      loggedInUsers: loggedInUsers ?? this.loggedInUsers,
      anonymousUsers: anonymousUsers ?? this.anonymousUsers,
      subscribedUsers: subscribedUsers ?? this.subscribedUsers,
      recentLogs: recentLogs ?? this.recentLogs,
      users: users ?? this.users,
      tournaments: tournaments ?? this.tournaments,
      games: games ?? this.games,
    );
  }
}

class DashboardError extends DashboardState {
  final String error;

  const DashboardError(this.error);

  @override
  List<Object> get props => [error];
}
