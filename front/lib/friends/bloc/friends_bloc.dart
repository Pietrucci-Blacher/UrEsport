import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/models/friend.dart';
import 'package:uresport/core/services/friends_services.dart';
import 'package:uresport/friends/bloc/friends_event.dart';
import 'package:uresport/friends/bloc/friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final FriendService friendService;

  FriendsBloc(this.friendService) : super(FriendsInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<ToggleFavorite>(_onToggleFavorite);
    on<DeleteFriend>(_onDeleteFriend);
    on<SortFriends>(_onSortFriends);
  }

  Future<void> _onLoadFriends(
      LoadFriends event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      final friends = await friendService.fetchFriends(event.userId);
      friends.sort((a, b) =>
          a.firstname.compareTo(b.firstname)); // Sort alphabetically by default
      emit(FriendsLoaded(
          friends: friends,
          isSorted: true)); // Indicate that the list is sorted alphabetically
    } catch (e) {
      emit(FriendsError('Failed to load friends: $e'));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<FriendsState> emit) async {
    if (state is FriendsLoaded) {
      final currentState = state as FriendsLoaded;
      try {
        await friendService.updateFavoriteStatus(
            event.userId, event.friend.id, !event.friend.isFavorite);
        final updatedFriends = currentState.friends.map((friend) {
          return friend.id == event.friend.id
              ? friend.copyWith(isFavorite: !friend.isFavorite)
              : friend;
        }).toList();
        emit(FriendsLoaded(
            friends: updatedFriends, isSorted: currentState.isSorted));
      } catch (e) {
        emit(FriendsError('Failed to update favorite status: $e'));
      }
    }
  }

  Future<void> _onDeleteFriend(
      DeleteFriend event, Emitter<FriendsState> emit) async {
    if (state is FriendsLoaded) {
      final currentState = state as FriendsLoaded;
      try {
        await friendService.deleteFriend(event.userId, event.friend.id);
        final updatedFriends = currentState.friends
            .where((friend) => friend.id != event.friend.id)
            .toList();
        emit(FriendsLoaded(
            friends: updatedFriends, isSorted: currentState.isSorted));
      } catch (e) {
        emit(FriendsError('Failed to delete friend: $e'));
      }
    }
  }

  void _onSortFriends(SortFriends event, Emitter<FriendsState> emit) {
    if (state is FriendsLoaded) {
      final currentState = state as FriendsLoaded;
      final sortedFriends = List<Friend>.from(currentState.friends);
      sortedFriends.sort((a, b) {
        return currentState.isSorted
            ? b.firstname.compareTo(a.firstname)
            : a.firstname.compareTo(b.firstname);
      });
      emit(FriendsLoaded(
          friends: sortedFriends, isSorted: !currentState.isSorted));
    }
  }
}
