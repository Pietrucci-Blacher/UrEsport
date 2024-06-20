import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:provider/provider.dart';

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
              UpvoteButton(tournament: tournament), // Utiliser le widget personnalisé
            ],
          ),
        ),
      ),
    );
  }
}

class UpvoteButton extends StatefulWidget {
  final Tournament tournament;

  const UpvoteButton({Key? key, required this.tournament}) : super(key: key);

  @override
  _UpvoteButtonState createState() => _UpvoteButtonState();
}

class _UpvoteButtonState extends State<UpvoteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  bool _isUpvoted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.deepOrange,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _upvoteTournament() async {
    final tournamentService = Provider.of<ITournamentService>(context, listen: false);

    try {
      await tournamentService.upvoteTournament(widget.tournament.id, 'username');
      setState(() {
        _isUpvoted = !_isUpvoted;
      });
      if (_isUpvoted) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upvote successful')),
      );
    } catch (e) {
      print('Upvote failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upvote: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _upvoteTournament,
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Icon(
              Icons.local_fire_department,
              color: _colorAnimation.value,
            ),
          ),
          const SizedBox(width: 4),
          Text('${widget.tournament.upvotes + (_isUpvoted ? 1 : 0)}'), // Affiche le nombre de upvotes
        ],
      ),
    );
  }
}
