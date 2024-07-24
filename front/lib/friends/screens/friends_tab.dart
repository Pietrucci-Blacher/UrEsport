import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/models/friend.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/friends_services.dart';
import 'package:uresport/friends/bloc/friends_bloc.dart';
import 'package:uresport/friends/bloc/friends_event.dart';
import 'package:uresport/friends/bloc/friends_state.dart';
import 'package:uresport/friends/screens/friends_add.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/widgets/friend_list_title.dart';

class FriendsTab extends StatefulWidget {
  final int userId;

  const FriendsTab({
    super.key,
    required this.userId,
  });

  @override
  FriendsTabState createState() => FriendsTabState();
}

class FriendsTabState extends State<FriendsTab> {
  late FriendsBloc _friendsBloc;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _friendsBloc = FriendsBloc(FriendService(Dio(BaseOptions(
      baseUrl: dotenv.env['API_ENDPOINT']!,
    ))));
  }

  @override
  void dispose() {
    _friendsBloc.close();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final authService = Provider.of<IAuthService>(context, listen: false);
    try {
      final user = await authService.getUser();
      if (!mounted) return;
      setState(() {
        _currentUser = user;
      });
      _friendsBloc.add(LoadFriends(user.id));
    } catch (e) {
      debugPrint('Error loading current user: $e');
    }
  }

  Future<void> _navigateAndRefresh(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFriendPage(
          userId: _currentUser!.id,
          currentUser: _currentUser!.username,
        ),
      ),
    );

    _friendsBloc.add(LoadFriends(_currentUser!.id));
  }

  Future<void> _handleRefresh() async {
    if (_currentUser != null) {
      _friendsBloc.add(LoadFriends(_currentUser!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => _friendsBloc,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: BlocBuilder<FriendsBloc, FriendsState>(
                  builder: (context, state) {
                    if (state is FriendsLoaded) {
                      return ElevatedButton(
                        onPressed: () {
                          context.read<FriendsBloc>().add(SortFriends());
                        },
                        child: Text(state.isSorted ? l.sortZToA : l.sortAToZ),
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
                      return Center(child: Text(l.noFriendsFound));
                    }

                    final friends = state.friends;
                    final favoriteFriends =
                        friends.where((friend) => friend.isFavorite).toList();
                    final nonFavoriteFriends =
                        friends.where((friend) => !friend.isFavorite).toList();

                    final groupedFavoriteFriends = <String, List<Friend>>{};
                    for (var friend in favoriteFriends) {
                      final firstLetter = friend.firstname[0].toUpperCase();
                      groupedFavoriteFriends
                          .putIfAbsent(firstLetter, () => [])
                          .add(friend);
                    }

                    final groupedFriends = <String, List<Friend>>{};
                    for (var friend in nonFavoriteFriends) {
                      final firstLetter = friend.firstname[0].toUpperCase();
                      groupedFriends
                          .putIfAbsent(firstLetter, () => [])
                          .add(friend);
                    }

                    return RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: ListView(
                        children: [
                          if (groupedFavoriteFriends.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                l.favorites,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ...groupedFavoriteFriends.entries.expand((entry) {
                            return [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ...entry.value.map((friend) => Dismissible(
                                  key: UniqueKey(),
                                  direction: DismissDirection.horizontal,
                                  confirmDismiss: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      return await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(l.confirm),
                                                content: Text(
                                                    '${l.confirmDeleteFriend} ${friend.name} ?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: Text(l.no),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child: Text(l.yes),
                                                  ),
                                                ],
                                              );
                                            },
                                          ) ??
                                          false;
                                    } else {
                                      return true;
                                    }
                                  },
                                  onDismissed: (direction) {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      context.read<FriendsBloc>().add(
                                          DeleteFriend(
                                              friend, _currentUser!.id));
                                    } else {
                                      context.read<FriendsBloc>().add(
                                          ToggleFavorite(
                                              friend, _currentUser!.id));
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: const Icon(Icons.remove_circle,
                                          color: Colors.white),
                                    ),
                                    child: GestureDetector(
                                      child: FriendListTile(
                                          name:
                                              "${friend.firstname} ${friend.lastname}"),
                                    ),
                                  )),
                            ];
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Text(
                              l.friends,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...groupedFriends.entries.expand((entry) {
                            return [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ...entry.value.map((friend) => Dismissible(
                                    key: UniqueKey(),
                                    direction: DismissDirection.horizontal,
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        return await showDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Confirmation'),
                                                  content: Text(
                                                      '${l.confirmDeleteFriend} ${friend.firstname} ${friend.lastname} ?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: Text(l.no),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      child: Text(l.yes),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ) ??
                                            false;
                                      } else {
                                        return true;
                                      }
                                    },
                                    onDismissed: (direction) {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        context.read<FriendsBloc>().add(
                                            DeleteFriend(
                                                friend, _currentUser!.id));
                                      } else {
                                        context.read<FriendsBloc>().add(
                                            ToggleFavorite(
                                                friend, _currentUser!.id));
                                      }
                                    },
                                    background: Container(
                                      color: Colors.green,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: const Icon(Icons.star,
                                          color: Colors.white),
                                    ),
                                    secondaryBackground: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: const Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                    child: GestureDetector(
                                      child: FriendListTile(
                                          name:
                                              "${friend.firstname} ${friend.lastname}"),
                                    ),
                                  )),
                            ];
                          }),
                        ],
                      ),
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
          tooltip: l.addFriend,
          child: const Icon(Icons.person_add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
