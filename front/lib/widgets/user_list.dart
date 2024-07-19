import 'package:flutter/material.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/shared/utils/invite_button.dart';
import 'package:uresport/shared/utils/join_button.dart';
import 'package:uresport/game/screens/game_screen.dart';
import 'package:uresport/l10n/app_localizations.dart';

class UserList extends StatelessWidget {
  final String tournamentId;
  final AuthService authService;

  const UserList(
      {super.key, required this.tournamentId, required this.authService});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    return FutureBuilder<List<User>>(
      future: authService.fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(l.failedToLoadUsers));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(l.noUsersFound));
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
                        child: Text(l.viewGames),
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
