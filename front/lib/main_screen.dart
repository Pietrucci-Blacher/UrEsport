import 'package:flutter/material.dart';
import 'package:uresport/home/screens/home_screen.dart';
import 'package:uresport/notification/screens/notif_screen.dart';
import 'package:uresport/profile/screens/profile_screen.dart';
import 'package:uresport/shared/navigation/bottom_navigation.dart';
import 'package:uresport/tournament/screens/tournament_screen.dart';
import 'package:uresport/widgets/invite_button.dart';
import 'package:uresport/widgets/qrcode.dart';
import 'package:uresport/widgets/scan_qrcode.dart';



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
          const InviteButton(username: 'votre_username'), // Remplacez 'votre_username' par le nom d'utilisateur réel
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRViewExample()),
              );
            },
            child: const Text('Scan QR Code'),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        isLoggedIn: isLoggedIn,
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}