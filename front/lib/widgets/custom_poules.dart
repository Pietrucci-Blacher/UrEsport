import 'package:flutter/material.dart';

class CustomPoulesPage extends StatelessWidget {
  const CustomPoulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poules de Tournois'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
    return ListView.builder(
      itemCount: poules.length,
      itemBuilder: (context, index) {
        final poule = poules[index];
        poule.teams.sort((a, b) => int.parse(b.score).compareTo(int.parse(a.score))); // Tri par score décroissant
        return Card(
          margin: EdgeInsets.all(10),
          child: ExpansionTile(
            title: Text(poule.name),
            children: poule.teams.map((team) {
              return ListTile(
                title: Text(team.name),
                trailing: Text(team.score),
              );
            }).toList(),
          ),
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
  final String score;
}
