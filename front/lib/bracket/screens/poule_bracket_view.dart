import 'package:flutter/material.dart';
import 'package:uresport/bracket/models/poule.dart';
import 'package:uresport/bracket/models/team.dart';
import 'package:uresport/l10n/app_localizations.dart';

class PouleBracketView extends StatefulWidget {
  final List<Poule> poules;

  const PouleBracketView({super.key, required this.poules});

  @override
  PouleBracketViewState createState() => PouleBracketViewState();
}

class PouleBracketViewState extends State<PouleBracketView> {
  final Map<String, Map<String, String>> matchResults = {};

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.pouleBrackets),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: widget.poules.map((poule) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: ExpansionTile(
                title: Text(
                  poule.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        border: TableBorder.all(),
                        defaultColumnWidth: const FixedColumnWidth(120.0),
                        children: _buildRoundRobinTableRows(poule.teams, l),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<TableRow> _buildRoundRobinTableRows(List<Team> teams, AppLocalizations l) {
    List<TableRow> rows = [];

    // Add header row
    rows.add(
      TableRow(
        children: [
          TableCell(child: Container()),
          ...teams.map((team) => Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                team.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          )),
        ],
      ),
    );

    for (int i = 0; i < teams.length; i++) {
      List<Widget> cells = [];
      cells.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            teams[i].name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

      for (int j = 0; j < teams.length; j++) {
        if (i == j) {
          cells.add(
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '---',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          cells.add(
            GestureDetector(
              onTap: () {
                _showResultDialog(context, teams[i], teams[j], l);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  matchResults[teams[i].name]?[teams[j].name] ?? l.vs,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ),
          );
        }
      }

      rows.add(TableRow(children: cells));
    }

    return rows;
  }

  void _showResultDialog(BuildContext context, Team team1, Team team2, AppLocalizations l) {
    final TextEditingController scoreController1 = TextEditingController();
    final TextEditingController scoreController2 = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${l.enterResult} ${team1.name} vs ${team2.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: scoreController1,
                decoration: InputDecoration(
                  labelText: '${team1.name} ${l.score}',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: scoreController2,
                decoration: InputDecoration(
                  labelText: '${team2.name} ${l.score}',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(l.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(l.save),
              onPressed: () {
                setState(() {
                  matchResults[team1.name] = matchResults[team1.name] ?? {};
                  matchResults[team2.name] = matchResults[team2.name] ?? {};
                  matchResults[team1.name]![team2.name] =
                  '${scoreController1.text} - ${scoreController2.text}';
                  matchResults[team2.name]![team1.name] =
                  '${scoreController2.text} - ${scoreController1.text}';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
