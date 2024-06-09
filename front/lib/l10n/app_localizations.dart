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

  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: 'Login button text',
    );
  }

  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: 'Register button text',
    );
  }

  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: 'Email field label',
    );
  }

  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'Password field label',
    );
  }

  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: 'Welcome message',
    );
  }

  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: 'First name field label',
    );
  }

  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: 'Last name field label',
    );
  }

  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: 'Username field label',
    );
  }

  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: 'Reset Password button text',
    );
  }

  String get sendResetEmail {
    return Intl.message(
      'Send Reset Email',
      name: 'sendResetEmail',
      desc: 'Send Reset Email button text',
    );
  }

  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: 'Verify button text',
    );
  }

  String get enterEmailToResetPassword {
    return Intl.message(
      'Enter your email to reset password',
      name: 'enterEmailToResetPassword',
      desc: 'Reset Password instruction text',
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

  String get youAreNotLoggedIn {
    return Intl.message(
      'You are not logged in',
      name: 'youAreNotLoggedIn',
      desc: 'Message when the user is not logged in',
    );
  }

  String get logIn {
    return Intl.message(
      'Log In',
      name: 'logIn',
      desc: 'Log In button text',
    );
  }

  String get orLoginWith {
    return Intl.message(
      'Or login with',
      name: 'orLoginWith',
      desc: 'Text for login with other providers',
    );
  }

  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: 'Forgot Password button text',
    );
  }

  String get passwordResetEmailSent {
    return Intl.message(
      'Password reset email sent',
      name: 'passwordResetEmailSent',
      desc: 'Password reset email sent message',
    );
  }

  String get passwordResetSuccessful {
    return Intl.message(
      'Password reset successful',
      name: 'passwordResetSuccessful',
      desc: 'Password reset successful message',
    );
  }

  String profileScreenWelcome(String username) {
    return Intl.message(
      'Welcome to your profile, $username!',
      name: 'profileScreenWelcome',
      desc: 'Welcome message for the profile screen',
      args: [username],
    );
  }

  String verificationCodeSent(String email) {
    return Intl.message(
      'A verification code has been sent to $email.',
      name: 'verificationCodeSent',
      desc: 'Verification code sent message',
      args: [email],
    );
  }

  String get resendCode {
    return Intl.message(
      'Resend Code',
      name: 'resendCode',
      desc: 'Resend code title',
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
