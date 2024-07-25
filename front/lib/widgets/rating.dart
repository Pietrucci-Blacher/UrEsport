import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/rating_service.dart';
import 'package:uresport/l10n/app_localizations.dart';

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
  RatingWidgetState createState() => RatingWidgetState();
}

class RatingWidgetState extends State<RatingWidget> {
  double _currentRating = 0.0;
  bool _isLoading = true;
  int? _ratingId;

  @override
  void initState() {
    super.initState();
    _fetchRating();
  }

  Future<void> _fetchRating() async {
    final ratingService = Provider.of<IRatingService>(context, listen: false);
    try {
      final ratingData = await ratingService.fetchRatingDetails(
          widget.tournamentId, widget.userId);
      if (!mounted) return;
      setState(() {
        _currentRating = ratingData['rating'];
        _ratingId = ratingData['ratingId'];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error while fetching rating: $e');
      if (!mounted) return;
      widget.showCustomToast(
          context, AppLocalizations.of(context).errorFetchingRating,
          backgroundColor: Colors.red);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitOrUpdateRating(double rating) async {
    final ratingService = Provider.of<IRatingService>(context, listen: false);

    if (rating == 0.0) {
      widget.showCustomToast(
          context, AppLocalizations.of(context).ratingCannotBeZero,
          backgroundColor: Colors.red);
      return;
    }

    try {
      debugPrint(
          'Submitting or updating rating for tournamentId=${widget.tournamentId}, userId=${widget.userId}, rating=$rating');
      if (_ratingId != null) {
        await ratingService.updateRating(
            widget.tournamentId, _ratingId!, widget.userId, rating);
      } else {
        await ratingService.submitRating(
            widget.tournamentId, widget.userId, rating);
      }
      if (!mounted) return;
      widget.showCustomToast(
          context, AppLocalizations.of(context).ratingSavedSuccessfully,
          backgroundColor: Colors.green);
      setState(() {
        _currentRating = rating;
      });
    } catch (e) {
      debugPrint('Error while submitting or updating rating: $e');
      if (!mounted) return;
      widget.showCustomToast(
          context, AppLocalizations.of(context).errorSavingRating,
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.yourRating,
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
