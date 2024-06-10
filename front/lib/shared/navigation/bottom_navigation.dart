import 'package:flutter/material.dart';
import 'package:uresport/l10n/app_localizations.dart';

class CustomBottomNavigation extends StatelessWidget {
  final bool isLoggedIn;
  final int selectedIndex;
  final void Function(int index) onTap;
  final int notificationCount;

  const CustomBottomNavigation({
    super.key,
    required this.isLoggedIn,
    required this.selectedIndex,
    required this.onTap,
    required this.notificationCount, // Add this parameter
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
          icon: const Icon(Icons.games),
          label: AppLocalizations.of(context).gameScreenTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.sports_esports),
          label: AppLocalizations.of(context).tournamentScreenTitle,
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications),
              if (notificationCount > 0)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: AppLocalizations.of(context).notificationScreenTitle,
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey[600],
      showUnselectedLabels: true,
      onTap: onTap,
      type: BottomNavigationBarType.fixed, // This ensures fixed height and layout
    );
  }
}
