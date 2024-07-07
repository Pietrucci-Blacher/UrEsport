import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/core/services/rating_service.dart';
import 'package:uresport/shared/websocket/websocket.dart';
import 'package:uresport/shared/routing/routing.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final dio = Dio();
  final authService = AuthService(dio);
  final tournamentService = TournamentService(dio);
  final gameService = GameService(dio);

  // L'URL de base sera maintenant récupérée via dotenv dans le service
  final ratingService = RatingService(dio);

  final routeGenerator = RouteGenerator(authService);

  connectWebsocket();

  runApp(
    MultiProvider(
      providers: [
        Provider<IAuthService>.value(value: authService),
        Provider<ITournamentService>.value(value: tournamentService),
        Provider<IGameService>.value(value: gameService),
        Provider<IRatingService>.value(value: ratingService),
      ],
      child: MyApp(
        authService: authService,
        tournamentService: tournamentService,
        gameService: gameService,
        routeGenerator: routeGenerator,
      ),
    ),
  );
}
