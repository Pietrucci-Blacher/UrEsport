import 'package:flutter/material.dart';

class CustomPoulesPage extends StatelessWidget {
  const CustomPoulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poules de Tournois'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: TournamentPoules(),
    );
  }
}

class TournamentPoules extends StatefulWidget {
  @override
  _TournamentPoulesState createState() => _TournamentPoulesState();
}

class _TournamentPoulesState extends State<TournamentPoules> {
  final List<Poule> poules = [];

  @override
  void initState() {
    super.initState();
    _initializePoules();
  }

  void _initializePoules() {
    poules.add(Poule(name: 'Poule A', teams: [
      Team(name: 'Team 1', score: '3'),
      Team(name: 'Team 2', score: '1'),
      Team(name: 'Team 3', score: '2'),
      Team(name: 'Team 4', score: '0'),
      Team(name: 'Team 9', score: '1'),
    ]));
    poules.add(Poule(name: 'Poule B', teams: [
      Team(name: 'Team 5', score: '2'),
      Team(name: 'Team 6', score: '3'),
      Team(name: 'Team 7', score: '0'),
      Team(name: 'Team 8', score: '1'),
      Team(name: 'Team 10', score: '1'),
    ]));
    poules.add(Poule(name: 'Poule C', teams: [
      Team(name: 'Team 11', score: '4'),
      Team(name: 'Team 12', score: '2'),
      Team(name: 'Team 13', score: '1'),
      Team(name: 'Team 14', score: '3'),
      Team(name: 'Team 15', score: '0'),
    ]));
    poules.add(Poule(name: 'Poule D', teams: [
      Team(name: 'Team 16', score: '1'),
      Team(name: 'Team 17', score: '2'),
      Team(name: 'Team 18', score: '3'),
      Team(name: 'Team 19', score: '4'),
      Team(name: 'Team 20', score: '0'),
    ]));
    poules.add(Poule(name: 'Poule E', teams: [
      Team(name: 'Team 21', score: '3'),
      Team(name: 'Team 22', score: '1'),
      Team(name: 'Team 23', score: '2'),
      Team(name: 'Team 24', score: '4'),
      Team(name: 'Team 25', score: '0'),
    ]));
  }

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

class PouleBracketView extends StatefulWidget {
  final List<Poule> poules;

  const PouleBracketView({super.key, required this.poules});

  @override
  _PouleBracketViewState createState() => _PouleBracketViewState();
}

class _PouleBracketViewState extends State<PouleBracketView> {
  final Map<String, Map<String, String>> matchResults = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brackets des Poules'),
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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        border: TableBorder.all(),
                        defaultColumnWidth: const FixedColumnWidth(120.0),
                        children: _buildRoundRobinTableRows(poule.teams),
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

  List<TableRow> _buildRoundRobinTableRows(List<Team> teams) {
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
                _showResultDialog(context, teams[i], teams[j]);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  matchResults[teams[i].name]?[teams[j].name] ?? 'VS',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
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

  void _showResultDialog(BuildContext context, Team team1, Team team2) {
    final TextEditingController scoreController1 = TextEditingController();
    final TextEditingController scoreController2 = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter result for ${team1.name} vs ${team2.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: scoreController1,
                decoration: InputDecoration(
                  labelText: '${team1.name} Score',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: scoreController2,
                decoration: InputDecoration(
                  labelText: '${team2.name} Score',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  matchResults[team1.name] = matchResults[team1.name] ?? {};
                  matchResults[team2.name] = matchResults[team2.name] ?? {};
                  matchResults[team1.name]![team2.name] = '${scoreController1.text} - ${scoreController2.text}';
                  matchResults[team2.name]![team1.name] = '${scoreController2.text} - ${scoreController1.text}';
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

class Poule {
  Poule({
    required this.name,
    required this.teams,
  });

  final String name;
  final List<Team> teams;
}

class Team {
  Team({
    required this.name,
    required this.score,
  });

  final String name;
  String score;
}

void main() {
  runApp(const MaterialApp(
    home: CustomPoulesPage(),
  ));
}
