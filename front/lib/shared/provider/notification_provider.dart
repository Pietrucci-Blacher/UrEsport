import 'package:flutter/material.dart';
import 'package:uresport/core/models/invit.dart';

class NotificationProvider with ChangeNotifier {
  final List<String> _notifications = [];
  final List<Invit> _invitations = [];

  List<String> get notifications => _notifications;
  List<Invit> get invitations => _invitations;

  int get notificationCount => _notifications.length + _invitations.length;

  void addNotification(String message) {
    _notifications.add(message);
    notifyListeners();
  }

  void addInvitation(Invit invit) {
    _invitations.add(invit);
    notifyListeners();
  }

  void addInvitations(List<Invit> invits) {
    _invitations.addAll(invits);
    notifyListeners();
  }

  void removeNotification(int index) {
    _notifications.removeAt(index);
    notifyListeners();
  }

  void removeInvitation(int index) {
    _invitations.removeAt(index);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void clearInvitations() {
    _invitations.clear();
  }

  void clearNotificationCount() {
    _notifications.clear();
  }
}
