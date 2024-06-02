import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/services/notification_service.dart';
import '../../widgets/notification_card.dart';

class NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationService>(
      builder: (context, notificationService, child) {
        final notifications = notificationService.notifications;
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(
              imageUrl: notification['image']!,
              message: notification['message']!,
            );
          },
        );
      },
    );
  }
}
