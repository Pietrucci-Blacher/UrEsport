import 'package:flutter/material.dart';
import 'package:uresport/core/models/friend.dart';
import 'package:uresport/l10n/app_localizations.dart';

class FriendsDetails extends StatelessWidget {
  final Friend friend;

  const FriendsDetails({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.friendDetails),
      ),
      body: Center(
        child: Text(
          '${l.friendDetails} ${friend.firstname}', // Use friend's details
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
