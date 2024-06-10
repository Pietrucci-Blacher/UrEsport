import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uresport/services/friends_services.dart';
import 'package:uresport/models/friend.dart';
import 'package:uresport/widgets/friend_list_tile.dart';
import 'package:uresport/notification/screens/friends_add.dart';
import 'package:uresport/notification/screens/friends_details.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  _FriendsTabState createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> with AutomaticKeepAliveClientMixin<FriendsTab> {
  Future<List<Friend>>? futureFriends;
  List<Friend> friends = [];
  bool isSorted = false;

  int get currentUserId => 21;

  @override
  void initState() {
    super.initState();
    loadFriends();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadFriends();
  }

  void loadFriends() async {
    futureFriends = FriendService.fetchFriends();
    friends = await futureFriends!;
    setState(() {});
  }

  void toggleFavorite(Friend friend) async {
    try {
      await FriendService.updateFavoriteStatus(currentUserId, friend.id,!friend.isFavorite);
      setState(() {
        friend.isFavorite =!friend.isFavorite;
        friends = List.from(friends);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to update favorite status: $e');
      }
    }
  }

  void deleteFriend(Friend friend) async {
    try {
      await FriendService.deleteFriend(currentUserId, friend.id);
      setState(() {
        friends.remove(friend);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete friend: $e');
      }
    }
  }

  void navigateToFriendDetails(Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendsDetails(friend: friend),
      ),
    );
  }

  void sortFriends(List<Friend> friends) {
    friends.sort((a, b) {
      if (isSorted) {
        return b.name.compareTo(a.name);
      } else {
        return a.name.compareTo(b.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isSorted =!isSorted;
                    sortFriends(friends);
                  });
                },
                child: Text(isSorted? 'Trier Z-A' : 'Trier A-Z'),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Friend>>(
              future: futureFriends,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load friends'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No friends found'));
                } else {
                  friends = snapshot.data!;
                  sortFriends(friends);

                  List<Friend> favoriteFriends = friends.where((friend) => friend.isFavorite).toList();
                  List<Friend> nonFavoriteFriends = friends.where((friend) =>!friend.isFavorite).toList();

                  Map<String, List<Friend>> groupedFriends = {};
                  for (var friend in nonFavoriteFriends) {
                    String firstLetter = friend.name[0].toUpperCase();
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
                          setState(() {
                            toggleFavorite(friend);
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.remove_circle, color: Colors.white),
                        ),
                        child: InkWell(
                          onTap: () => navigateToFriendDetails(friend),
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
                          ...entry.value.map((friend) => InkWell(
                            onTap: () {
                              print('Tapped on ${friend.name}');
                              navigateToFriendDetails(friend);
                            },
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.horizontal,
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      bool confirmDelete = false;
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text('Voulez-vous vraiment supprimer ${friend.name} de vos amis ?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false); // Annuler la suppression
                                            },
                                            child: Text('Non'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              confirmDelete = true;
                                              Navigator.of(context).pop(true); // Confirmer la suppression
                                            },
                                            child: Text('Oui'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return true;
                                }
                              },
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                  deleteFriend(friend);
                                } else {
                                  toggleFavorite(friend);
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
                              child: ListTile(
                                title: FriendListTile(name: friend.name),
                              ),
                            ),
                          )),


                        ];
                      }),
                    ],
                  );
                }
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
              builder: (context) => const AddFriendPage(userId: 21, currentUser: 'ilies'),
            ),
          );
          loadFriends();
        },
        child: const Icon(Icons.person_add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
