// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `UrEsport`
  String get appTitle {
    return Intl.message(
      'UrEsport',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homeScreenTitle {
    return Intl.message(
      'Home',
      name: 'homeScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tournaments`
  String get tournamentScreenTitle {
    return Intl.message(
      'Tournaments',
      name: 'tournamentScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationScreenTitle {
    return Intl.message(
      'Notifications',
      name: 'notificationScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileScreenTitle {
    return Intl.message(
      'Profile',
      name: 'profileScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Home Screen!`
  String get homeScreenWelcome {
    return Intl.message(
      'Welcome to the Home Screen!',
      name: 'homeScreenWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Tournament Screen!`
  String get tournamentScreenWelcome {
    return Intl.message(
      'Welcome to the Tournament Screen!',
      name: 'tournamentScreenWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Notification screen!`
  String get notificationScreenWelcome {
    return Intl.message(
      'Welcome to the Notification screen!',
      name: 'notificationScreenWelcome',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
