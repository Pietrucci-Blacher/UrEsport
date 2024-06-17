import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uresport/core/models/tournament.dart';

class TournamentDetailsScreen extends StatelessWidget {
  final Tournament tournament;

  const TournamentDetailsScreen({super.key, required this.tournament});
  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(
        title: Text(tournament.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'tournamentHero${tournament.id}',
                child: Image.network(
                  tournament.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tournament.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Description:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                tournament.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Location: ${tournament.location}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Start Date: ${dateFormat.format(tournament.startDate)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'End Date: ${dateFormat.format(tournament.endDate)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Participants:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
