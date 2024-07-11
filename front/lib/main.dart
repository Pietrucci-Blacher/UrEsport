import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/friends_services.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/core/services/map_service.dart';
import 'package:uresport/core/services/notification_service.dart';
import 'package:uresport/core/services/rating_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/shared/provider/notification_provider.dart';
import 'package:uresport/shared/routing/routing.dart';
import 'package:uresport/shared/websocket/websocket.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final dio = Dio(BaseOptions(
    baseUrl: kIsWeb ? 'http://localhost:8080' : dotenv.env['API_ENDPOINT']!,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    followRedirects: true,
    maxRedirects: 5,
  ));

  if (kIsWeb) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Origin'] = 'http://localhost:3000';
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 301 || e.response?.statusCode == 302) {
          final redirectUrl = e.response?.headers.value('Location');
          if (redirectUrl != null) {
            final newOptions = Options(
              method: e.requestOptions.method,
              headers: e.requestOptions.headers,
            );
            dio.request(redirectUrl, options: newOptions).then((response) {
              handler.resolve(response);
            }).catchError((error) {
              handler.reject(error);
            });
            return;
          }
        }
        return handler.next(e);
      },
    ));

    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  final authService = AuthService(dio);
  final tournamentService = TournamentService(dio);
  final gameService = GameService(dio);

  final ratingService = RatingService(dio);

  final routeGenerator = RouteGenerator(authService);
  final friendService = FriendService(dio);
  final mapsBoxApiKey = dotenv.env['SDK_REGISTRY_TOKEN']!;
  final mapService = MapService(dio: dio, mapboxApiKey: mapsBoxApiKey);

  if (kIsWeb) {
    connectWebsocket();
  }

  runApp(
    MultiProvider(
      providers: [
        Provider<IAuthService>.value(value: authService),
        Provider<ITournamentService>.value(value: tournamentService),
        Provider<IGameService>.value(value: gameService),
        Provider<IRatingService>.value(value: ratingService),
        Provider<IFriendService>.value(value: friendService),
        ChangeNotifierProvider<NotificationService>(
            create: (_) => NotificationService()),
        ChangeNotifierProvider<NotificationProvider>(
            create: (_) => NotificationProvider()),
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
