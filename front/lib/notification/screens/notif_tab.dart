import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/shared/provider/notification_provider.dart';
import 'package:uresport/widgets/custom_toast.dart'; // Importer le widget personnalisé
import 'package:uresport/widgets/notification_card.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        final notifications = notificationProvider.notifications;
        return Stack(
          children: [
            if (notifications.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_off,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).noNotifications,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      notificationProvider.removeNotification(index);
                      showNotificationToast(
                        context,
                        AppLocalizations.of(context).notificationDeleted,
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: NotificationCard(
                      message: notification,
                      imageUrl: notification,
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  void showNotificationToast(BuildContext context, String message,
      {Color? backgroundColor, Color? textColor}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomToast(
        message: message,
        backgroundColor: backgroundColor ??
            Colors.grey, // Valeur par défaut pour la couleur de fond
        textColor: textColor ??
            Colors.white, // Valeur par défaut pour la couleur du texte
        onClose: () {
          overlayEntry.remove();
        },
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
