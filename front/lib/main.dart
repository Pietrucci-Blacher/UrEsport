import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/friends_services.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/core/services/map_service.dart';
import 'package:uresport/core/services/notification_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/core/services/match_service.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/shared/provider/notification_provider.dart';
import 'package:uresport/core/services/rating_service.dart';
import 'package:uresport/shared/websocket/websocket.dart';
import 'package:uresport/shared/routing/routing.dart';

import 'app.dart';
import 'auth/bloc/auth_event.dart';
import 'core/websocket/websocket.dart';
import 'dashboard/bloc/dashboard_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final dio = Dio();

  if (kIsWeb) {
    dio.options.validateStatus = (status) {
      return status! < 500;
    };

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Content-Type'] = 'application/json';
        options.headers['Accept'] = 'application/json';
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 405 || e.response?.statusCode == 403) {
          return handler.resolve(Response(
            requestOptions: e.requestOptions,
            statusCode: 200,
          ));
        }
        return handler.next(e);
      },
    ));

    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  final authService = AuthService(dio);
  final tournamentService = TournamentService(dio);
  final gameService = GameService(dio);
  final matchService = MatchService(dio);

  // L'URL de base sera maintenant récupérée via dotenv dans le service
  final ratingService = RatingService(dio);

  final routeGenerator = RouteGenerator(authService);
  final friendService = FriendService(dio);
  final mapsBoxApiKey = dotenv.env['SDK_REGISTRY_TOKEN']!;
  final mapService = MapService(dio: dio, mapboxApiKey: mapsBoxApiKey);

  connectWebsocket();

  runApp(
    MultiProvider(
      providers: [
        Provider<IAuthService>.value(value: authService),
        Provider<ITournamentService>.value(value: tournamentService),
        Provider<IGameService>.value(value: gameService),
        Provider<IRatingService>.value(value: ratingService),
        Provider<IFriendService>.value(value: friendService),
        Provider<IMatchService>.value(value: matchService),
        ChangeNotifierProvider<NotificationService>(
            create: (_) => NotificationService()),
        ChangeNotifierProvider<NotificationProvider>(
            create: (_) => NotificationProvider()),
        Provider<MapService>.value(value: mapService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authService)..add(AuthCheckRequested()),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(
                Websocket.getInstance(), tournamentService, gameService)
              ..add(FetchTournaments())
              ..add(FetchGames()),
          ),
        ],
        child: MyApp(
          authService: authService,
          tournamentService: tournamentService,
          gameService: gameService,
          mapService: mapService,
          routeGenerator: routeGenerator,
        ),
      ),
    ),
  );
}
