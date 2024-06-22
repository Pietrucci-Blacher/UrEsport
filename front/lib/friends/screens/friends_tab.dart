import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/services/friends_services.dart';
import 'package:uresport/core/models/friend.dart';
import 'package:uresport/widgets/friend_list_title.dart';
import 'package:uresport/friends/screens/friends_add.dart';
import 'package:dio/dio.dart';
import 'package:uresport/friends/bloc/friends_bloc.dart';
import 'package:uresport/friends/bloc/friends_event.dart';
import 'package:uresport/friends/bloc/friends_state.dart';


class FriendsTab extends StatefulWidget {
  final int userId;

  const FriendsTab({
    super.key,
    required this.userId,
  });

  @override FriendsTabState createState() => FriendsTabState();
}

class FriendsTabState extends State<FriendsTab> {
  late FriendsBloc _friendsBloc;

  @override
  void initState() {
    super.initState();
    _friendsBloc = FriendsBloc(FriendService(Dio(BaseOptions(
      baseUrl: dotenv.env['API_ENDPOINT']!,
    ))));
    _friendsBloc.add(LoadFriends(widget.userId));
  }

  @override
  void dispose() {
    _friendsBloc.close();
    super.dispose();
  }

  Future<void> _navigateAndRefresh(BuildContext context) async {
    // Naviguer vers AddFriendPage et attendre jusqu'à ce que la page soit fermée
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFriendPage(userId: widget.userId, currentUser: 'ilies'),
      ),
    );

    // Recharger les amis après être revenu de AddFriendPage
    _friendsBloc.add(LoadFriends(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _friendsBloc,
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
              child: BlocConsumer<FriendsBloc, FriendsState>(
                listener: (context, state) {
                  if (state is FriendsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
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
                            context.read<FriendsBloc>().add(ToggleFavorite(friend, widget.userId));
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.remove_circle, color: Colors.white),
                          ),
                          child: GestureDetector(
                            //onTap: () => navigateToFriendDetails(context, friend),
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
                                  context.read<FriendsBloc>().add(DeleteFriend(friend, widget.userId));
                                } else {
                                  context.read<FriendsBloc>().add(ToggleFavorite(friend, widget.userId));
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
                                //onTap: () => navigateToFriendDetails(context, friend),
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
          onPressed: () => _navigateAndRefresh(context),
          child: const Icon(Icons.person_add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}