import 'package:flutter/material.dart';
import '../../widgets/friend_list_tile.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({Key? key}) : super(key: key);

  @override
  _FriendsTabState createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  List<Map<String, String>> friends = [
    {'name': 'Alice', 'favorite': 'true'},
    {'name': 'Bob', 'favorite': 'false'},
    {'name': 'Charlie', 'favorite': 'false'},
    {'name': 'David', 'favorite': 'true'},
    {'name': 'Eve', 'favorite': 'false'},
    {'name': 'Zack', 'favorite': 'true'},
    // Add more friends here
  ];

  bool isSorted = false;

  void toggleFavorite(String name) {
    setState(() {
      for (var friend in friends) {
        if (friend['name'] == name) {
          friend['favorite'] = (friend['favorite'] == 'true') ? 'false' : 'true';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> favoriteFriends = friends.where((friend) => friend['favorite'] == 'true').toList();
    List<Map<String, String>> nonFavoriteFriends = friends.where((friend) => friend['favorite'] == 'false').toList();

    if (isSorted) {
      favoriteFriends.sort((a, b) => a['name']!.compareTo(b['name']!));
      nonFavoriteFriends.sort((a, b) => a['name']!.compareTo(b['name']!));
    } else {
      favoriteFriends.sort((a, b) => b['name']!.compareTo(a['name']!));
      nonFavoriteFriends.sort((a, b) => b['name']!.compareTo(a['name']!));
    }

    Map<String, List<Map<String, String>>> groupedFriends = {};

    for (var friend in nonFavoriteFriends) {
      String firstLetter = friend['name']![0].toUpperCase();
      if (!groupedFriends.containsKey(firstLetter)) {
        groupedFriends[firstLetter] = [];
      }
      groupedFriends[firstLetter]!.add(friend);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Amis',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isSorted = !isSorted;
                });
              },
              child: Text(isSorted ? 'Trier Z-A' : 'Trier A-Z'),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              // Favorites block
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  'Favoris',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...favoriteFriends.map((friend) => FriendListTile(name: friend['name']!)).toList(),
              // Grouped friends by letter
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
                    key: Key(friend['name']!),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      setState(() {
                        toggleFavorite(friend['name']!);
                      });
                    },
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.star, color: Colors.white),
                    ),
                    child: FriendListTile(name: friend['name']!),
                  )).toList(),
                ];
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
