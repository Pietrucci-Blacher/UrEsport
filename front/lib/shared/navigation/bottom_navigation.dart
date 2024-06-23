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

  void _showErrorToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomToast(
        message: message,
        onClose: () {
          overlayEntry?.remove();
        },
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
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
      if (!isLoggedIn)
        BottomNavigationBarItem(
          icon: const Icon(Icons.notifications_off),
          label: AppLocalizations.of(context).notificationScreenTitle,
        ),
    ];

    // Add notification item only if the user is logged in
    if (isLoggedIn) {
      items.add(
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
      );
    }

    return BottomNavigationBar(
      items: items,
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey[600],
      showUnselectedLabels: true,
      onTap: (index) {
        if (index == 3 && !isLoggedIn) {
          _showErrorToast(context, 'Vous devez être connecté pour accéder aux notifications.');
        } else {
          onTap(index);
        }
      },
      type: BottomNavigationBarType.fixed,
    );
  }
}

class CustomToast extends StatelessWidget {
  final String message;
  final VoidCallback onClose;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;

  const CustomToast({
    super.key,
    required this.message,
    required this.onClose,
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
    this.duration = const Duration(seconds: 3),
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50.0,
      left: MediaQuery.of(context).size.width * 0.1,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: 14.0),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: textColor),
                onPressed: onClose,
                iconSize: 16.0,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
