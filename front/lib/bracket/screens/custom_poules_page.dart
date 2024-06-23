import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/bracket/bloc/poule_bloc.dart';
import 'package:uresport/bracket/bloc/events.dart';
import 'package:uresport/bracket/bloc/states.dart';
import 'package:uresport/bracket/models/poule.dart';
import 'package:uresport/bracket/screens/poule_bracket_view.dart';


class CustomPoulesPage extends StatelessWidget {
  const CustomPoulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PouleBloc()..add(LoadPoules()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Poules de Tournois'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocBuilder<PouleBloc, PouleState>(
          builder: (context, state) {
            if (state is PouleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PouleLoaded) {
              return TournamentPoules(poules: state.poules);
            } else if (state is PouleError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}

class TournamentPoules extends StatelessWidget {
  final List<Poule> poules;

  const TournamentPoules({required this.poules, super.key});

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