import 'package:flutter/material.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/dashboard/screens/edit_tournament_page.dart';

class TournamentsScreen extends StatelessWidget {
  final DashboardLoaded state;

  const TournamentsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            controller: scrollController,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Start Date')),
                DataColumn(label: Text('End Date')),
                DataColumn(label: Text('Location')),
                DataColumn(label: Text('Latitude')),
                DataColumn(label: Text('Longitude')),
                DataColumn(label: Text('Owner ID')),
                DataColumn(label: Text('Image')),
                DataColumn(label: Text('Private')),
                DataColumn(label: Text('Nb Players')),
                DataColumn(label: Text('Created At')),
                DataColumn(label: Text('Updated At')),
                DataColumn(label: Text('Upvotes')),
                DataColumn(label: Text('')), // Empty column for spacing
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
                  DataCell(Container()), // Empty cell for spacing
                ]);
              }).toList(),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: SizedBox(
            width: 100, // Set the width for the fixed column
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Actions')),
              ],
              rows: state.tournaments.map((tournament) {
                return DataRow(cells: [
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditTournamentPage(
                                      tournament: tournament)),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                                context, tournament.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int tournamentId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Tournament'),
          content:
              const Text('Are you sure you want to delete this tournament?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
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
