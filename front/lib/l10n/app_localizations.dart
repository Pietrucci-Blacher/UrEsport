import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:uresport/generated/l10n/intl/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode?.isEmpty ?? false
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  String get title {
    return Intl.message(
      'UrEsport',
      name: 'title',
      desc: 'The application title',
    );
  }

  String get welcome {
    return Intl.message(
      'Welcome to UrEsport!',
      name: 'welcome',
      desc: 'Welcome message',
    );
  }

  String get homeScreenWelcome {
    return Intl.message(
      'Welcome to the Home Screen!',
      name: 'homeScreenWelcome',
      desc: 'Welcome message for the Home screen',
    );
  }

  String get tournamentScreenWelcome {
    return Intl.message(
      'Welcome to the Tournament Screen!',
      name: 'tournamentScreenWelcome',
      desc: 'Welcome message for the Tournament screen',
    );
  }

  String get notificationScreenWelcome {
    return Intl.message(
      'Welcome to the Notification screen!',
      name: 'notificationScreenWelcome',
      desc: 'Welcome message for the Notification screen',
    );
  }

  String get homeScreenTitle {
    return Intl.message(
      'Home',
      name: 'homeScreenTitle',
      desc: 'Title for the Home screen',
    );
  }

  String get tournamentScreenTitle {
    return Intl.message(
      'Tournaments',
      name: 'tournamentScreenTitle',
      desc: 'Title for the Tournament screen',
    );
  }

  String get notificationScreenTitle {
    return Intl.message(
      'Notifications',
      name: 'notificationScreenTitle',
      desc: 'Title for the Notification screen',
    );
  }

  String get profileScreenTitle {
    return Intl.message(
      'Profile',
      name: 'profileScreenTitle',
      desc: 'Title for the Profile screen',
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
