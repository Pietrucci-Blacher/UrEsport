import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:uresport/app.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/shared/routing/routing.dart';
import 'auth/mocks/auth_service_mock.dart';
import 'tournament/mocks/tournament_service_mock.dart';
import 'game/mocks/game_service_mock.dart';

void main() {
  testWidgets('LocaleSwitcher changes locale', (WidgetTester tester) async {
    final mockAuthService = MockAuthService();
    final mockTournamentService = MockTournamentService();
    final mockGameService = MockGameService();

    when(mockAuthService.isLoggedIn()).thenAnswer((_) async => false);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<IAuthService>.value(value: mockAuthService),
          Provider<ITournamentService>.value(value: mockTournamentService),
          Provider<IGameService>.value(value: mockGameService),
        ],
        child: MyApp(
          authService: mockAuthService,
          tournamentService: mockTournamentService,
          gameService: mockGameService,
          routeGenerator: RouteGenerator(mockAuthService),
        ),
      ),
    );

    // Verify the initial state
    expect(find.byIcon(Icons.language), findsOneWidget);

    // Tap the floating action button to open the dialog
    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();

    // Verify the dialog opens with language options
    expect(find.text('Select Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Spanish'), findsOneWidget);
    expect(find.text('French'), findsOneWidget);

    // Select Spanish and verify the app now uses the Spanish locale
    await tester.tap(find.text('Spanish'));
    await tester.pumpAndSettle();
    expect(find.text('¡Bienvenido a UrEsport!'), findsOneWidget);

    // Select French and verify the app now uses the French locale
    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();
    await tester.tap(find.text('French'));
    await tester.pumpAndSettle();
    expect(find.text('Bienvenue à UrEsport!'), findsOneWidget);
  });
}
