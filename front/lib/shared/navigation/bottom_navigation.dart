import 'dart:ui';
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
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // Adjust opacity as needed
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2), // Adjust opacity as needed
              width: 1.0,
            ),
          ),
          child: BottomNavigationBar(
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
            selectedItemColor: Colors.red, // Set the color for selected items
            unselectedItemColor: Colors.white, // Set the color for unselected items
            showUnselectedLabels: true,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent, // Make background transparent
          ),
        ),
      ),
    );
  }
}
