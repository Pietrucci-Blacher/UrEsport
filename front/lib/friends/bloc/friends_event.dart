import 'package:equatable/equatable.dart';
import 'package:uresport/core/models/friend.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class LoadFriends extends FriendsEvent {
  final int userId;

  const LoadFriends(this.userId);

  @override
  List<Object> get props => [userId];
}

class ToggleFavorite extends FriendsEvent {
  final Friend friend;
  final int userId;

  const ToggleFavorite(this.friend, this.userId);

  @override
  List<Object> get props => [friend, userId];
}

class DeleteFriend extends FriendsEvent {
  final Friend friend;
  final int userId;

  const DeleteFriend(this.friend, this.userId);

  @override
  List<Object> get props => [friend, userId];
}

class SortFriends extends FriendsEvent {}