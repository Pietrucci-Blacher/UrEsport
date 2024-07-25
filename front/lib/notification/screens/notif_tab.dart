import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/shared/provider/notification_provider.dart';
import 'package:uresport/widgets/custom_toast.dart'; // Importer le widget personnalisé
import 'package:uresport/widgets/notification_card.dart';
import 'package:uresport/core/services/invit_service.dart';
import 'package:uresport/core/models/invit.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  NotificationsTabState createState() => NotificationsTabState();
}

class NotificationsTabState extends State<NotificationsTab> {
  @override
  void initState() {
    super.initState();
    _fetchInvitations();
  }

  _fetchInvitations() async {
    final invitService = Provider.of<IInvitService>(context, listen: false);
    final notifProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    try {
      notifProvider.clearInvitations();
      final teamInvitations =
          await invitService.fetchInvitations('tournaments', 'inbound');
      final tournamentInvitations =
          await invitService.fetchInvitations('teams', 'inbound');
      notifProvider.addInvitations(teamInvitations);
      notifProvider.addInvitations(tournamentInvitations);
    } catch (e) {
      throw Exception('Failed to load invitation: $e');
    }
  }

  _acceptInvitation(int id, Invit invitation) async {
    final invitService = Provider.of<IInvitService>(context, listen: false);
    final notifProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notifProvider.removeInvitation(id);

    if (invitation.type == 'team') {
      invitService.updateTeamInvitation(invitation.team.id, 'accept');
    } else {
      invitService.updateTournamentInvitation(
          invitation.tournament.id, invitation.team.id, 'accept');
    }

    showNotificationToast(context, 'Invitation acceptée',
        backgroundColor: Colors.green);
  }

  _rejectInvitation(int id, Invit invitation) async {
    final invitService = Provider.of<IInvitService>(context, listen: false);
    final notifProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notifProvider.removeInvitation(id);

    if (invitation.type == 'team') {
      invitService.updateTeamInvitation(invitation.team.id, 'reject');
    } else {
      invitService.updateTournamentInvitation(
          invitation.tournament.id, invitation.team.id, 'reject');
    }

    showNotificationToast(context, 'Invitation rejetée',
        backgroundColor: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        final notifications = notificationProvider.notifications;
        final invitations = notificationProvider.invitations;
        return Stack(
          children: [
            if (notifications.isEmpty && invitations.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_off,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).noNotifications,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            if (invitations.isNotEmpty)
              ListView.builder(
                itemCount: invitations.length,
                itemBuilder: (context, index) {
                  final invitation = invitations[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        _acceptInvitation(index, invitation);
                      } else if (direction == DismissDirection.startToEnd) {
                        _rejectInvitation(index, invitation);
                      }
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.green,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                    child: NotificationCard(
                      message: invitation.message,
                      imageUrl: invitation.tournament.image,
                    ),
                  );
                },
              ),
            if (notifications.isNotEmpty)
              ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      notificationProvider.removeNotification(index);
                      showNotificationToast(
                        context,
                        AppLocalizations.of(context).notificationDeleted,
                      );
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
