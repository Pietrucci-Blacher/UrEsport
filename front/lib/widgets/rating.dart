import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/rating_service.dart';

class RatingWidget extends StatefulWidget {
  final int tournamentId;
  final int userId;
  final Function(BuildContext, String,
      {Color? backgroundColor, Color? textColor}) showCustomToast;

  const RatingWidget({
    super.key,
    required this.tournamentId,
    required this.userId,
    required this.showCustomToast,
  });

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _currentRating = 0.0;
  bool _isLoading = true;
  int? _ratingId; // Ajouter une variable pour stocker l'ID de la note

  @override
  void initState() {
    super.initState();
    _fetchRating();
  }

  Future<void> _fetchRating() async {
    final ratingService = Provider.of<IRatingService>(context, listen: false);
    try {
      print(
          'Fetching rating for tournamentId=${widget.tournamentId}, userId=${widget.userId}');
      final ratingData = await ratingService.fetchRatingDetails(
          widget.tournamentId, widget.userId);
      setState(() {
        _currentRating = ratingData['rating'];
        _ratingId = ratingData['ratingId'];
        _isLoading = false;
      });
      if (_currentRating == 0.0) {
        widget.showCustomToast(context, 'Aucune note n\'a été récupérée',
            backgroundColor: Colors.orange);
      } else {
        widget.showCustomToast(context, 'Note récupérée avec succès',
            backgroundColor: Colors.green);
      }
    } catch (e) {
      print('Error while fetching rating: $e');
      widget.showCustomToast(
          context, 'Erreur lors de la récupération de la note',
          backgroundColor: Colors.red);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitOrUpdateRating(double rating) async {
    final ratingService = Provider.of<IRatingService>(context, listen: false);

    // Vérifier si la note est égale à zéro
    if (rating == 0.0) {
      widget.showCustomToast(context, 'La note ne peut pas être zéro',
          backgroundColor: Colors.red);
      return;
    }

    try {
      print(
          'Submitting or updating rating for tournamentId=${widget.tournamentId}, userId=${widget.userId}, rating=$rating');
      if (_ratingId != null) {
        // Si une note existe déjà, mettre à jour la note
        await ratingService.updateRating(
            widget.tournamentId, _ratingId!, widget.userId, rating);
      } else {
        // Sinon, soumettre une nouvelle note
        await ratingService.submitRating(
            widget.tournamentId, widget.userId, rating);
      }
      widget.showCustomToast(context, 'Note enregistrée avec succès',
          backgroundColor: Colors.green);
      setState(() {
        _currentRating = rating;
      });
    } catch (e) {
      print('Error while submitting or updating rating: $e');
      widget.showCustomToast(
          context, 'Erreur lors de l\'enregistrement de la note',
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Votre note:',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              RatingBar.builder(
                initialRating: _currentRating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  _submitOrUpdateRating(rating);
                },
              ),
            ],
          );
  }
}
