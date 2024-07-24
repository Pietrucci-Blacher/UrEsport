import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/friends/screens/friends_tab.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/notification/screens/notif_tab.dart';
import 'package:uresport/shared/provider/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            tabs: [
              Consumer<NotificationProvider>(
                builder: (context, notificationProvider, child) {
                  return Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l.notifications),
                        if (notificationProvider.notificationCount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${notificationProvider.notificationCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              Tab(text: l.friends),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NotificationsTab(),
            FriendsTab(
              userId: 21,
            ),
          ],
        ),
      ),
    );
  }
}
