import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatefulWidget {
  final bool isLoggedIn;
  final int selectedIndex;
  final void Function(int index) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.isLoggedIn,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  CustomBottomNavigationState createState() => CustomBottomNavigationState();
}

class CustomBottomNavigationState extends State<CustomBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_esports),
          label: 'Tournaments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'QRCode',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey[600],
      onTap: widget.onTap,
    );
  }
}
