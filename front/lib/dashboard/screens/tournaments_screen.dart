import 'package:flutter/material.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/dashboard/screens/edit_tournament_page.dart';
import 'package:uresport/l10n/app_localizations.dart';

class TournamentsScreen extends StatelessWidget {
  final DashboardLoaded state;

  const TournamentsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);
    final ScrollController scrollController = ScrollController();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        controller: scrollController,
        child: DataTable(
          columns: [
            DataColumn(label: Text(l.idText)),
            DataColumn(label: Text(l.name)),
            DataColumn(label: Text(l.description)),
            DataColumn(label: Text(l.startDate)),
            DataColumn(label: Text(l.endDate)),
            DataColumn(label: Text(l.location)),
            DataColumn(label: Text(l.latitude)),
            DataColumn(label: Text(l.longitude)),
            DataColumn(label: Text(l.ownerIDText)),
            DataColumn(label: Text(l.imageText)),
            DataColumn(label: Text(l.private)),
            DataColumn(label: Text(l.numberOfPlayers)),
            DataColumn(label: Text(l.createdAtText)),
            DataColumn(label: Text(l.updatedAtText)),
            DataColumn(label: Text(l.upvotes)),
            DataColumn(label: Text(l.actionsText)),
          ],
          rows: state.tournaments.map((tournament) {
            return DataRow(cells: [
              DataCell(Text(tournament.id.toString())),
              DataCell(Text(tournament.name)),
              DataCell(Text(tournament.description)),
              DataCell(Text(tournament.startDate.toIso8601String())),
              DataCell(Text(tournament.endDate.toIso8601String())),
              DataCell(Text(tournament.location)),
              DataCell(Text(tournament.latitude.toString())),
              DataCell(Text(tournament.longitude.toString())),
              DataCell(Text(tournament.ownerId.toString())),
              DataCell(Text(tournament.image)),
              DataCell(Text(tournament.isPrivate.toString())),
              DataCell(Text(tournament.nbPlayers.toString())),
              DataCell(Text(tournament.startDate.toIso8601String())),
              DataCell(Text(tournament.endDate.toIso8601String())),
              DataCell(Text(tournament.upvotes.toString())),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTournamentPage(tournament: tournament),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, tournament.id);
                      },
                    ),
                  ],
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int tournamentId) {
    AppLocalizations l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l.deleteTournament),
          content: Text(l.confirmDeleteTournament),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l.cancel),
            ),
            /*TextButton(
              onPressed: () {
                BlocProvider.of<DashboardBloc>(context)
                    .add(DeleteTournamentEvent(tournamentId));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),*/
          ],
        );
      },
    );
  }
}
