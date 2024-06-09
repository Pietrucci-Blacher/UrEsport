import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/NotificationProvider.dart';
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
          bottom: TabBar(
            tabs: [
              Consumer<NotificationProvider>(
                builder: (context, notificationProvider, child) {
                  return Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Notifications'),
                        if (notificationProvider.notificationCount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
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
                              '${notificationProvider.notificationCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const Tab(text: 'Amis'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NotificationsTab(),
            FriendsTab(),
          ],
        ),
      ),
    );
  }
}
