import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uresport/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLocalizations English', () {
    testWidgets('loads English translations', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              final localizations = AppLocalizations.of(context);
              expect(localizations.homeScreenTitle, 'Home');
              expect(localizations.tournamentScreenTitle, 'Tournaments');
              expect(localizations.notificationScreenTitle, 'Notifications');
              expect(localizations.profileScreenTitle, 'Profile');
              expect(localizations.homeScreenWelcome,
                  'Welcome to the Home Screen!');
              expect(localizations.tournamentScreenWelcome,
                  'Welcome to the Tournament Screen!');
              expect(localizations.notificationScreenWelcome,
                  'Welcome to the Notification screen!');
              return Container();
            },
          ),
        ),
      ));
    });
  });
}
