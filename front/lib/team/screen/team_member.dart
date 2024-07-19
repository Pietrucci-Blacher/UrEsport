import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/team_services.dart';
import 'package:uresport/widgets/custom_toast.dart';
import 'package:uresport/l10n/app_localizations.dart';

import 'package:uresport/core/services/auth_service.dart';

class TeamMembersPage extends StatelessWidget {
  final int teamId;
  final List<User> members;
  final int ownerId;
  final int currentId;
  final String teamName;

  const TeamMembersPage({
    super.key,
    required this.teamId,
    required this.members,
    required this.ownerId,
    required this.currentId,
    required this.teamName,
  });

  Future<void> _kickUser(
      BuildContext context, int teamId, String username) async {
    final teamService = Provider.of<ITeamService>(context, listen: false);
    try {
      await teamService.kickUserFromTeam(teamId, username);
      if (!context.mounted) return;
      _showToast(
          context,
          AppLocalizations.of(context).userKickedSuccess(username),
          Colors.green);
    } catch (e) {
      debugPrint(AppLocalizations.of(context).errorKickingUser(e.toString()));
      _showToast(
          context,
          AppLocalizations.of(context).errorKickingUser(e.toString()),
          Colors.red);
    }
  }

  Future<void> _inviteUser(BuildContext context, String username) async {
    final teamService = Provider.of<ITeamService>(context, listen: false);
    try {
      await teamService.inviteUserToTeam(teamId, username);
      if (!context.mounted) return;
      _showToast(
          context, '$username a bien été invité à la team', Colors.green);
    } catch (e) {
      debugPrint('Erreur lors de l\'invitation du user: $e');
      _showToast(
          context, 'Erreur lors de l\'invitation du user: $e', Colors.red);
    }
  }

  void _showInviteDialog(BuildContext context) {
    final authService = Provider.of<IAuthService>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<User>>(
          future: authService.fetchUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Aucun utilisateur trouvé'));
            } else {
              final users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.profileImageUrl ??
                          'https://via.placeholder.com/150'),
                    ),
                    title: Text(user.username),
                    subtitle: Text('${user.firstname} ${user.lastname}'),
                    onTap: () {
                      Navigator.pop(context);
                      _inviteUser(context, user.username);
                    },
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  void _showToast(BuildContext context, String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: CustomToast(
          message: message,
          backgroundColor: backgroundColor,
          onClose: () {
            overlayEntry.remove();
          },
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  Future<bool> _confirmKickUser(BuildContext context, String username) async {
    AppLocalizations l = AppLocalizations.of(context);
    return (await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(l.confirmKick),
              content: Text(l.confirmKickMessage(username)),
              actions: <Widget>[
                TextButton(
                  child: Text(l.cancel),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text(l.kick),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.membersOfTeam(teamName)),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return ownerId == currentId
              ? Dismissible(
                  key: Key(member.id.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await _confirmKickUser(context, member.username);
                  },
                  onDismissed: (direction) async {
                    await _kickUser(context, teamId, member.username);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(member.profileImageUrl ??
                          'https://via.placeholder.com/150'),
                    ),
                    title: Row(
                      children: [
                        Text(member.username),
                        if (member.id == ownerId) ...[
                          const SizedBox(width: 5),
                          const Icon(Icons.verified,
                              color: Colors.amber, size: 20),
                        ],
                      ],
                    ),
                    subtitle: Text('${member.firstname} ${member.lastname}'),
                  ),
                )
              : ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(member.profileImageUrl ??
                        'https://via.placeholder.com/150'),
                  ),
                  title: Row(
                    children: [
                      Text(member.username),
                      if (member.id == ownerId) ...[
                        const SizedBox(width: 5),
                        const Icon(Icons.verified,
                            color: Colors.amber, size: 20),
                      ],
                    ],
                  ),
                  subtitle: Text('${member.firstname} ${member.lastname}'),
                );
        },
      ),
      floatingActionButton: ownerId == currentId
          ? FloatingActionButton(
              onPressed: () => _showInviteDialog(context),
              child: const Icon(Icons.person_add),
            )
          : null,
    );
  }
}
