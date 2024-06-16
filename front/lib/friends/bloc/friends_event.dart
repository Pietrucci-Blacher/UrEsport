import 'package:equatable/equatable.dart';
import 'package:uresport/models/friend.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class LoadFriends extends FriendsEvent {}

class ToggleFavorite extends FriendsEvent {
  final Friend friend;

  const ToggleFavorite(this.friend);

  @override
  List<Object> get props => [friend];
}

class DeleteFriend extends FriendsEvent {
  final Friend friend;

  const DeleteFriend(this.friend);

  @override
  List<Object> get props => [friend];
}

class SortFriends extends FriendsEvent {}
