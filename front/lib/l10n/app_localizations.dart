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

  String get inviteButtonTitle {
    return Intl.message(
      'Invite',
      name: 'inviteButtonTitle',
      desc: 'Title for the Invite button',
    );
  }

  String get inviteSuccessTitle {
    return Intl.message(
      'Invite Success',
      name: 'inviteSuccessTitle',
      desc: 'Title for the invite success dialog',
    );
  }

  String get inviteErrorTitle {
    return Intl.message(
      'Invite Error',
      name: 'inviteErrorTitle',
      desc: 'Title for the invite error dialog',
    );
  }

  String get closeButtonTitle {
    return Intl.message(
      'Close',
      name: 'closeButtonTitle',
      desc: 'Title for the close button',
    );
  }

  String get joinButtonTitle {
    return Intl.message(
      'Join',
      name: 'JoinButtonTitle',
      desc: 'Title for the Join button',
    );
  }

  String get gameButtonTitle {
    return Intl.message(
      'Games',
      name: 'gameButtonTitle',
      desc: 'Title for the Games button',
    );
  }

  String get gameScreenWelcome {
    return Intl.message(
      'Welcome to the Games screen!',
      name: 'gameScreenWelcome',
      desc: 'Welcome message for the Games screen',
    );
  }

  String get gameScreenTitle {
    return Intl.message(
      'Games',
      name: 'gameScreenTitle',
      desc: 'Title for the Games screen',
    );
  }

  String get modifyGameButtonTitle {
    return Intl.message(
      'Modify',
      name: 'modifyGameButtonTitle',
      desc: 'Title for the Modify button',
    );
  }

  String get deleteGameButtonTitle {
    return Intl.message(
      'Delete',
      name: 'deleteGameButtonTitle',
      desc: 'Title for the Delete button',
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
