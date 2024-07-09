// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/intl/messages_all.dart';

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

  /// `Welcome to UrEsport`
  String get welcome {
    return Intl.message(
      'Welcome to UrEsport',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Email`
  String get sendResetEmail {
    return Intl.message(
      'Send Reset Email',
      name: 'sendResetEmail',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to your profile, {username}!`
  String profileScreenWelcome(Object username) {
    return Intl.message(
      'Welcome to your profile, $username!',
      name: 'profileScreenWelcome',
      desc: '',
      args: [username],
    );
  }

  /// `You are not logged in`
  String get youAreNotLoggedIn {
    return Intl.message(
      'You are not logged in',
      name: 'youAreNotLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get logIn {
    return Intl.message(
      'Log In',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Or login with`
  String get orLoginWith {
    return Intl.message(
      'Or login with',
      name: 'orLoginWith',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password reset email sent`
  String get passwordResetEmailSent {
    return Intl.message(
      'Password reset email sent',
      name: 'passwordResetEmailSent',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successful`
  String get passwordResetSuccessful {
    return Intl.message(
      'Password reset successful',
      name: 'passwordResetSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `A verification code has been sent to {email}.`
  String verificationCodeSent(Object email) {
    return Intl.message(
      'A verification code has been sent to $email.',
      name: 'verificationCodeSent',
      desc: '',
      args: [email],
    );
  }

  /// `Resend code`
  String get resendCode {
    return Intl.message(
      'Resend code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Invite`
  String get inviteButton {
    return Intl.message(
      'Invite',
      name: 'inviteButton',
      desc: '',
      args: [],
    );
  }

  /// `You have been invited successfully`
  String get inviteSuccess {
    return Intl.message(
      'You have been invited successfully',
      name: 'inviteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while sending the invitation`
  String get inviteError {
    return Intl.message(
      'An error occurred while sending the invitation',
      name: 'inviteError',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get closeButton {
    return Intl.message(
      'Close',
      name: 'closeButton',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get joinButton {
    return Intl.message(
      'Join',
      name: 'joinButton',
      desc: '',
      args: [],
    );
  }

  /// `All Games`
  String get gameButton {
    return Intl.message(
      'All Games',
      name: 'gameButton',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Game Screen!`
  String get gameScreenWelcome {
    return Intl.message(
      'Welcome to the Game Screen!',
      name: 'gameScreenWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Games`
  String get gameScreenTitle {
    return Intl.message(
      'Games',
      name: 'gameScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Modify Game`
  String get modifyGameButton {
    return Intl.message(
      'Modify Game',
      name: 'modifyGameButton',
      desc: '',
      args: [],
    );
  }

  /// `Delete Game`
  String get deleteGameButton {
    return Intl.message(
      'Delete Game',
      name: 'deleteGameButton',
      desc: '',
      args: [],
    );
  }

  /// `Trending Tournaments`
  String get trendingTournamentsTitle {
    return Intl.message(
      'Trending Tournaments',
      name: 'trendingTournamentsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Popular Games`
  String get popularGamesTitle {
    return Intl.message(
      'Popular Games',
      name: 'popularGamesTitle',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Danger Zone`
  String get dangerZone {
    return Intl.message(
      'Danger Zone',
      name: 'dangerZone',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Editing`
  String get cancelEditing {
    return Intl.message(
      'Cancel Editing',
      name: 'cancelEditing',
      desc: '',
      args: [],
    );
  }

  /// `Filters ({count})`
  String filters(Object count) {
    return Intl.message(
      'Filters ($count)',
      name: 'filters',
      desc: '',
      args: [count],
    );
  }

  /// `Filter and Sort`
  String get filterAndSort {
    return Intl.message(
      'Filter and Sort',
      name: 'filterAndSort',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Search tags`
  String get searchTags {
    return Intl.message(
      'Search tags',
      name: 'searchTags',
      desc: '',
      args: [],
    );
  }

  /// `FILTER BY TAGS`
  String get filterByTags {
    return Intl.message(
      'FILTER BY TAGS',
      name: 'filterByTags',
      desc: '',
      args: [],
    );
  }

  /// `SORT`
  String get sort {
    return Intl.message(
      'SORT',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filters`
  String get applyFilters {
    return Intl.message(
      'Apply Filters',
      name: 'applyFilters',
      desc: '',
      args: [],
    );
  }

  /// `Alphabetical (A-Z)`
  String get alphabeticalAZ {
    return Intl.message(
      'Alphabetical (A-Z)',
      name: 'alphabeticalAZ',
      desc: '',
      args: [],
    );
  }

  /// `Alphabetical (Z-A)`
  String get alphabeticalZA {
    return Intl.message(
      'Alphabetical (Z-A)',
      name: 'alphabeticalZA',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred!`
  String get anErrorOccurred {
    return Intl.message(
      'An error occurred!',
      name: 'anErrorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `No games available.`
  String get noGamesAvailable {
    return Intl.message(
      'No games available.',
      name: 'noGamesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `+{count} more`
  String moreTagsCount(Object count) {
    return Intl.message(
      '+$count more',
      name: 'moreTagsCount',
      desc: '',
      args: [count],
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
