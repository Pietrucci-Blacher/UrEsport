import 'package:flutter/material.dart';
import 'notif_tab.dart';
import 'friends_tab.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Notifications'),
              Tab(text: 'Amis'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NotificationsTab(),
            FriendsTab(),
          ],
        ),
      ),
    );
  }
}
