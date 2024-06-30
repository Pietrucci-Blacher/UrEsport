import 'package:flutter/material.dart';

  class NotificationProvider with ChangeNotifier {
  final List<String> _notifications = [];

  List<String> get notifications => _notifications;

  int get notificationCount => _notifications.length;

  void addNotification(String message) {
    _notifications.add(message);
    notifyListeners();
  }

  void removeNotification(int index) {
    _notifications.removeAt(index);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void clearNotificationCount() {
    _notifications.clear();
  }
}