import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  final List<Map<String, String>> _notifications = [];

  List<Map<String, String>> get notifications => _notifications;

  void addNotification(String message, String imageUrl) {
    _notifications.add({'message': message, 'image': imageUrl});
    notifyListeners();
  }

  void removeNotification(int index) {
    _notifications.removeAt(index);
    notifyListeners();
  }
}
