import 'package:flutter/material.dart';
import 'package:uresport/l10n/app_localizations.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context).notificationScreenWelcome),
    );
  }
}
