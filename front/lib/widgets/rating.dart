import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/rating_service.dart';

class RatingWidget extends StatefulWidget {
  final int tournamentId;
  final Function(BuildContext, String, {Color? backgroundColor, Color? textColor}) showCustomToast;

  const RatingWidget({
    super.key,
    required this.tournamentId,
    required this.showCustomToast,
  });

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchRating();
  }

  Future<void> _fetchRating() async {
    final ratingService = Provider.of<IRatingService>(context, listen: false);
    try {
      final rating = await ratingService.getRating(widget.tournamentId); // Remplacez 'username' par l'ID ou le nom d'utilisateur réel
      setState(() {
        _currentRating = rating;
      });
    } catch (e) {
      widget.showCustomToast(context, 'Erreur lors de la récupération de la note', backgroundColor: Colors.red);
    }
  }

  Future<void> _submitRating(double rating) async {
    final ratingService = Provider.of<IRatingService>(context, listen: false);
    try {
      await ratingService.submitRating(widget.tournamentId, 1, rating); // Remplacez 'username' par l'ID ou le nom d'utilisateur réel
      widget.showCustomToast(context, 'Note enregistrée avec succès', backgroundColor: Colors.green);
      setState(() {
        _currentRating = rating;
      });
    } catch (e) {
      widget.showCustomToast(context, 'Erreur lors de l\'enregistrement de la note', backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Votre note:', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        RatingBar.builder(
          initialRating: _currentRating,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) {
            _submitRating(rating);
          },
        ),
      ],
    );
  }
}
