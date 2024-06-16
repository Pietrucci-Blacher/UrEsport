import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/services/friends_services.dart';
import 'package:uresport/models/friend.dart';
import 'friends_event.dart';
import 'friends_state.dart';
import 'package:dio/dio.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final FriendService friendService;

  FriendsBloc(this.friendService) : super(FriendsInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<ToggleFavorite>(_onToggleFavorite);
    on<DeleteFriend>(_onDeleteFriend);
    on<SortFriends>(_onSortFriends);
  }

  Future<void> _onLoadFriends(LoadFriends event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      final friends = await friendService.fetchFriends(event.userId);
      emit(FriendsLoaded(friends: friends, isSorted: false));
    } catch (e) {
      emit(FriendsError('Failed to load friends: $e'));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<FriendsState> emit) async {
    if (state is FriendsLoaded) {
      final currentState = state as FriendsLoaded;
      try {
        await friendService.updateFavoriteStatus(event.userId, event.friend.id, !event.friend.isFavorite);
        final updatedFriends = currentState.friends.map((friend) {
          return friend.id == event.friend.id ? friend.copyWith(is
