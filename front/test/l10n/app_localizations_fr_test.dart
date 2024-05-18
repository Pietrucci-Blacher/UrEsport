import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uresport/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLocalizations French', () {
    testWidgets('loads French translations', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final localizations = AppLocalizations.of(context);
              expect(localizations.homeScreenTitle, 'Accueil');
              expect(localizations.tournamentScreenTitle, 'Tournois');
              expect(localizations.notificationScreenTitle, 'Notifications');
              expect(localizations.profileScreenTitle, 'Profil');
              expect(localizations.homeScreenWelcome,
                  'Bienvenue à l\'écran d\'accueil !');
              expect(localizations.tournamentScreenWelcome,
                  'Bienvenue à l\'écran des tournois !');
              expect(localizations.notificationScreenWelcome,
                  'Bienvenue à l\'écran des notifications !');
              return Container();
            },
          ),
        ),
      ));
    });
  });
}
