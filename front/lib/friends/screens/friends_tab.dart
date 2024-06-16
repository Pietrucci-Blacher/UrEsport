import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/services/friends_services.dart';
import 'package:uresport/models/friend.dart';
import 'package:uresport/widgets/friend_list_tile.dart';
import 'package:uresport/notification/screens/friends_add.dart';
import 'package:uresport/notification/screens/friends_details.dart';
import 'package:dio/dio.dart';
import 'package:uresport/core/services/cache_service.dart';
import '../blocs/friends_bloc.dart';
import '../blocs/friends_event.dart';
import '../blocs/friends_state.dart';

class FriendsTab extends StatelessWidget {
  final int userId;

  const FriendsTab({Key? key, required this.userId}) : super(key: key);

  void navigateToFriendDetails(BuildContext context, Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendsDetails(friend: friend),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendsBloc(FriendService(Dio(BaseOptions(
        baseUrl: dotenv.env['API_ENDPOINT']!,
      ))))..add(LoadFriends(userId)),
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: BlocBuilder<FriendsBloc, FriendsState>(
                  builder: (context, state) {
                    if (state is FriendsLoaded) {
                      return ElevatedButton(
                        onPressed: () {
                          context.read<FriendsBloc>().add(SortFriends());
                        },
                        child: Text(state.isSorted ? 'Trier Z-A' : 'Trier A-Z'),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<FriendsBloc, FriendsState>(
                builder: (context, state) {
                  if (state is FriendsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FriendsError) {
                    return Center(child: Text(state.message));
                  } else if (state is FriendsLoaded) {
                    if (state.friends.isEmpty) {
                      return const Center(child: Text('No friends found'));
                    }

                    final friends = state.friends;
                    final favoriteFriends = friends.where((friend) => friend.isFavorite).toList();
                    final nonFavoriteFriends = friends.where((friend) => !friend.isFavorite).toList();

                    final groupedFriends = <String, List<Friend>>{};
                    for (var friend in nonFavoriteFriends) {
                      final firstLetter = friend.name[0].toUpperCase();
                      groupedFriends.putIfAbsent(firstLetter, () => []).add(friend);
                    }

                    return ListView(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            'Favoris',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...favoriteFriends.map((friend) => Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            context.read<FriendsBloc>().add(ToggleFavorite(friend, userId));
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.remove_circle, color: Colors.white),
                          ),
                          child: GestureDetector(
                            onTap: () => navigateToFriendDetails(context, friend),
                            child: FriendListTile(name: friend.name),
                          ),
                        )),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            'Amis',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...groupedFriends.entries.expand((entry) {
                          return [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                entry.key,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ...entry.value.map((friend) => Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.horizontal,
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  return await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: Text('Voulez-vous vraiment supprimer ${friend.name} de vos amis ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Non'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Oui'),
                                          ),
                                        ],
                                      );
                                    },
                                  ) ?? false;
                                } else {
                                  return true;
                                }
                              },
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                  context.read<FriendsBloc>().add(DeleteFriend(friend, userId));
                                } else {
                                  context.read<FriendsBloc>().add(ToggleFavorite(friend, userId));
                                }
                              },
                              background: Container(
                                color: Colors.green,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.star, color: Colors.white),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              child: GestureDetector(
                                onTap: () => navigateToFriendDetails(context, friend),
                                child: FriendListTile(name: friend.name),
                              ),
                            )),
                          ];
                        }),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddFriendPage(userId: userId, currentUser: 'ilies'),
              ),
            );
            context.read<FriendsBloc>().add(LoadFriends(userId));
          },
          child: const Icon(Icons.person_add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
