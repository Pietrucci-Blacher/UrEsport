import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uresport/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLocalizations Spanish', () {
    testWidgets('loads Spanish translations', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
          Locale('fr'),
        ],
        locale: const Locale('es'),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final localizations = AppLocalizations.of(context);
              expect(localizations.homeScreenTitle, 'Inicio');
              expect(localizations.tournamentScreenTitle, 'Torneos');
              expect(localizations.notificationScreenTitle, 'Notificaciones');
              expect(localizations.profileScreenTitle, 'Perfil');
              expect(localizations.homeScreenWelcome, '¡Bienvenido a la pantalla de inicio!');
              expect(localizations.tournamentScreenWelcome, '¡Bienvenido a la pantalla de torneos!');
              expect(localizations.notificationScreenWelcome, '¡Bienvenido a la pantalla de notificaciones!');
              return Container();
            },
          ),
        ),
      ));
    });
  });
}
