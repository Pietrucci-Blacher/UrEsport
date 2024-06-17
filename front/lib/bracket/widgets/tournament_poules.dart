import 'package:flutter/material.dart';

import 'package:uresport/bracket/models/poule.dart';
import 'package:uresport/bracket/screens/poule_bracket_view.dart';


class TournamentPoules extends StatelessWidget {
  final List<Poule> poules;

  const TournamentPoules({required this.poules});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: poules.length,
            itemBuilder: (context, index) {
              final poule = poules[index];
              poule.teams.sort((a, b) => int.parse(b.score).compareTo(int.parse(a.score)));
              return Card(
                margin: const EdgeInsets.all(10),
                child: ExpansionTile(
                  title: Text(
                    poule.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    _buildPouleTable(poule),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PouleBracketView(poules: poules),
                ),
              );
            },
            child: const Text('Voir les Brackets'),
          ),
        ),
      ],
    );
  }

  Widget _buildPouleTable(Poule poule) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1),
        },
        children: [
          const TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Team',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Score',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          ...poule.teams.map(
                (team) => TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(team.name),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      team.score,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}