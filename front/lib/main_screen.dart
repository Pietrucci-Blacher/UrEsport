import 'package:flutter/material.dart';
import 'package:uresport/home/screens/home_screen.dart';
import 'package:uresport/notification/screens/notif_screen.dart';
import 'package:uresport/profile/screens/profile_screen.dart';
import 'package:uresport/services/network_services.dart';
import 'package:uresport/shared/navigation/bottom_navigation.dart';
import 'package:uresport/tournament/screens/tournament_screen.dart';
import 'package:uresport/widgets/games_screen.dart';
import 'package:uresport/widgets/invite_button.dart';
import 'package:uresport/widgets/qrcode.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  bool isLoggedIn = false;

  final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const TournamentScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
    const QRCode(
      width: 200,
      height: 200,
      data: 'https://flutterflow.io', // Remplacez par les données que vous voulez encoder
    ),
  ];

  void _onItemTapped(int index) {
    if (index < _widgetOptions.length) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      debugPrint('Index $index est hors de la plage de _widgetOptions');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> usernames = ['user1', 'user2', 'user3', 'user4'];
    List<Widget> inviteButtons = usernames.map((username) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(username),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                String tournamentId = '1'; // Replace this with the actual tournamentId
                inviteUserToTournament(tournamentId, username, context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Inviter $username'),
                      content: Text('Bonjour $username, vous avez été invité au tournoi !'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Fermer'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Inviter'),
            ),
            ElevatedButton(
              onPressed: () {
                String tournamentId = '1'; // Replace this with the actual tournamentId
                // Ajoutez ici la logique pour rejoindre le tournoi
                bool joinSuccess = true; // Remplacez cela par votre logique réelle
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(joinSuccess ? 'Succès' : 'Échec'),
                      content: Text(joinSuccess ? 'Vous avez bien rejoint le tournoi !' : 'Impossible de rejoindre le tournoi.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Fermer'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Rejoindre'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GamesScreen()),
                );
              },
              child: Text('Voir les jeux'),
            )
          ],
        ),
      ],
    )).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('UrEsport'),
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
          ),
          Expanded(
            child: ListView(
              children: inviteButtons,
            ),
          ),
        ], //Children
      ),
      bottomNavigationBar: CustomBottomNavigation(
        isLoggedIn: isLoggedIn,
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
