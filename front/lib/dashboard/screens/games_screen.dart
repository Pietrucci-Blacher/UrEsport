import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/dashboard/screens/edit_game_page.dart';

class GamesScreen extends StatelessWidget {
  final DashboardLoaded state;

  const GamesScreen({super.key, required this.state});

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
                DataColumn(label: Text('Image URL')),
                DataColumn(label: Text('Tags')),
                DataColumn(label: Text('Created At')),
                DataColumn(label: Text('Updated At')),
                DataColumn(label: Text('')), // Empty column for spacing
              ],
              rows: state.games.map((game) {
                return DataRow(cells: [
                  DataCell(Text(game.id.toString())),
                  DataCell(Text(game.name)),
                  DataCell(Text(game.description)),
                  DataCell(Text(game.imageUrl)),
                  DataCell(Text(game.tags.join(', '))),
                  DataCell(Text(game.createdAt)),
                  DataCell(Text(game.updatedAt)),
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
              rows: state.games.map((game) {
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
                                  builder: (context) =>
                                      EditGamePage(game: game)),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, game.id);
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

  void _showDeleteConfirmationDialog(BuildContext context, int gameId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Game'),
          content: const Text('Are you sure you want to delete this game?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<DashboardBloc>(context)
                    .add(DeleteGameEvent(gameId));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
