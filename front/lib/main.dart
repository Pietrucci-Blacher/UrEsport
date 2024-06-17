import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/provider/NotificationProvider.dart';
import 'package:uresport/shared/websocket/websocket.dart';
import 'package:uresport/services/notification_service.dart'; // Import the NotificationProvider
import 'app.dart';
import 'package:uresport/core/services/friends_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final dio = Dio();
  final authService = AuthService(dio);
  final tournamentService = TournamentService(dio);
  final gameService = GameService(dio);
  final friendService = FriendService(dio);

  connectWebsocket();

  runApp(
    MultiProvider(
      providers: [
        Provider<IAuthService>.value(value: authService),
        Provider<ITournamentService>.value(value: tournamentService),
        Provider<IGameService>.value(value: gameService),
        Provider<IFriendService>.value(value: friendService),
        ChangeNotifierProvider<NotificationService>(create: (_) => NotificationService()),
        ChangeNotifierProvider<NotificationProvider>(create: (_) => NotificationProvider()), // Add the NotificationProvider
      ],
      child: MyApp(
          authService: authService,
          tournamentService: tournamentService,
          gameService: gameService,
      ),
    ),
  );
}
