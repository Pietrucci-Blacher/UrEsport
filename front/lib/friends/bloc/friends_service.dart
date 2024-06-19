import 'package:equatable/equatable.dart';
import 'package:uresport/core/models/friend.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

class FriendsInitial extends FriendsState {}

class FriendsLoading extends FriendsState {}

class FriendsLoaded extends FriendsState {
  final List<Friend> friends;
  final bool isSorted;

  const FriendsLoaded({required this.friends, required this.isSorted});

  @override
  List<Object> get props => [friends, isSorted];
}

class FriendsError extends FriendsState {
  final String message;

  const FriendsError(this.message);

  @override
  List<Object> get props => [message];
}