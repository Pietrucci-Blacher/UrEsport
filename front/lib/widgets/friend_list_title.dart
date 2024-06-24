import 'package:flutter/material.dart';

class FriendListTile extends StatelessWidget {
  final String name;

  const FriendListTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(name[0]),
      ),
      title: Text(name),
      onTap: () {
        // Action to perform on friends click
      },
    );
  }
}