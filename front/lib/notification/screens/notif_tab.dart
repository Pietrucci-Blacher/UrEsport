import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/widgets/custom_toast.dart'; // Importer le widget personnalisé

import 'package:uresport/shared/provider/NotificationProvider.dart';
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
            ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    notificationProvider.removeNotification(index);
                    showNotificationToast(context, 'Notification supprimée');
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
                    // Ajoutez la logique pour récupérer l'image si nécessaire
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
