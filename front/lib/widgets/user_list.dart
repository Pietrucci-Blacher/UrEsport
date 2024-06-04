import 'package:flutter/material.dart';
import 'package:uresport/core/services/user_service.dart';
import 'package:uresport/core/models/user.dart';
import 'invite_button.dart';
import 'join_button.dart';
import 'game_screen.dart';

class UserList extends StatelessWidget {
  final String tournamentId;

  const UserList({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: UserService.fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load users'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found'));
        } else {
          List<User> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              String username = users[index].username;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(username),
                  Row(
                    children: [
                      InviteButton(
                        username: username,
                        tournamentId: tournamentId,
                      ),
                      JoinButton(
                        username: username,
                        tournamentId: tournamentId,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GamesScreen()),
                          );
                        },
                        child: const Text('Voir les jeux'),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
