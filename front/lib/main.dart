import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/shared/provider/NotificationProvider.dart';
import 'package:uresport/shared/websocket/websocket.dart';
import 'package:uresport/shared/routing/routing.dart';
import 'package:uresport/core/services/notification_service.dart';
import 'package:uresport/core/services/map_service.dart';
import 'package:geolocator/geolocator.dart';
import 'app.dart';
import 'package:uresport/core/services/friends_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final dio = Dio();
  final authService = AuthService(dio);
  final tournamentService = TournamentService(dio);
  final gameService = GameService(dio);
  final routeGenerator = RouteGenerator(authService);
  final friendService = FriendService(dio);
  final googleApiKey = dotenv.env['MAPS_API_KEY']!;
  final geolocatorPlatform = GeolocatorPlatform.instance;
  final mapService = MapService(
    dio: dio,
    googleApiKey: googleApiKey,
    geolocatorPlatform: geolocatorPlatform,
  );

  connectWebsocket();

  runApp(
    MultiProvider(
      providers: [
        Provider<IAuthService>.value(value: authService),
        Provider<ITournamentService>.value(value: tournamentService),
        Provider<IGameService>.value(value: gameService),
        Provider<IFriendService>.value(value: friendService),
        ChangeNotifierProvider<NotificationService>(create: (_) => NotificationService()),
        ChangeNotifierProvider<NotificationProvider>(create: (_) => NotificationProvider()),
        Provider<MapService>.value(value: mapService),
      ],
      child: MyApp(
        authService: authService,
        tournamentService: tournamentService,
        gameService: gameService,
        mapService: mapService,
        routeGenerator: routeGenerator,
      ),
    ),
  );
}
