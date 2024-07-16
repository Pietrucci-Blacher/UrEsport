import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/team_services.dart';
import 'package:uresport/widgets/custom_toast.dart';

class TeamMembersPage extends StatelessWidget {
  final String teamName;
  final List<User> members;

  TeamMembersPage({required this.teamName, required this.members});

  Future<void> _kickUser(BuildContext context, String username) async {
    final teamService = Provider.of<ITeamService>(context, listen: false);
    try {
      await teamService.kickUserFromTeam(teamName, username);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$username has been kicked from the team')),
      );
    } catch (e) {
      _showToast(context, 'Failed to kick the user: $e', Colors.red);
    }
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
    return (await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Kick'),
          content: Text('Are you sure you want to kick $username from the team?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Kick'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members of $teamName'),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return Dismissible(
            key: Key(member.id.toString()),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await _confirmKickUser(context, member.username);
            },
            onDismissed: (direction) async {
              await _kickUser(context, member.username);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(member.profileImageUrl ?? 'https://via.placeholder.com/150'),
              ),
              title: Text(member.username),
              subtitle: Text('${member.firstname} ${member.lastname}'),
            ),
          );
        },
      ),
    );
  }
}
