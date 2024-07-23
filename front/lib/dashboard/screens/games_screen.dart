import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/dashboard/screens/edit_game_page.dart';
import 'package:uresport/l10n/app_localizations.dart';

class GamesScreen extends StatelessWidget {
  final DashboardLoaded state;

  const GamesScreen({super.key, required this.state});

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
            DataColumn(label: Text(l.imageText)),
            DataColumn(label: Text(l.tags)),
            DataColumn(label: Text(l.createdAtText)),
            DataColumn(label: Text(l.updatedAtText)),
            DataColumn(label: Text(l.actionsText)), // Actions column
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
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int gameId) {
    AppLocalizations l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l.deleteGameButton),
          content: Text(l.confirmDeleteGame),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<DashboardBloc>(context)
                    .add(DeleteGameEvent(gameId));
                Navigator.of(dialogContext).pop();
              },
              child: Text(l.delete),
            ),
          ],
        );
      },
    );
  }
}
