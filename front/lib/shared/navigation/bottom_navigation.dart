import 'package:flutter/material.dart';
import 'package:uresport/l10n/app_localizations.dart';

class CustomBottomNavigation extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppLocalizations.of(context).homeScreenTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.sports_esports),
          label: AppLocalizations.of(context).tournamentScreenTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.notifications),
          label: AppLocalizations.of(context).notificationScreenTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: AppLocalizations.of(context).profileScreenTitle,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'QRCode',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey[600],
      showUnselectedLabels: true,
      onTap: onTap,
      type:
          BottomNavigationBarType.fixed, // This ensures fixed height and layout
    );
  }
}
