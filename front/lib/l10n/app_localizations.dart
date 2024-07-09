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
      'Welcome to UrEsport!',
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

  String get inviteButton {
    return Intl.message(
      'Invite',
      name: 'inviteButton',
      desc: 'Title for the Invite button',
    );
  }

  String get inviteSuccess {
    return Intl.message(
      'You have been invited successfully',
      name: 'inviteSuccess',
      desc: 'Title for the invite success dialog',
    );
  }

  String get inviteError {
    return Intl.message(
      'An error occurred while sending the invitation',
      name: 'inviteError',
      desc: 'Title for the invite error dialog',
    );
  }

  String get closeButton {
    return Intl.message(
      'Close',
      name: 'closeButton',
      desc: 'Title for the close button',
    );
  }

  String get joinButton {
    return Intl.message(
      'Join',
      name: 'joinButton',
      desc: 'Title for the Join button',
    );
  }

  String get gameButton {
    return Intl.message(
      'All Games',
      name: 'gameButton',
      desc: 'Title for the Games button',
    );
  }

  String get gameScreenWelcome {
    return Intl.message(
      'Welcome to the Game Screen!',
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

  String get modifyGameButton {
    return Intl.message(
      'Modify Game',
      name: 'modifyGameButton',
      desc: 'Title for the Modify button',
    );
  }

  String get deleteGameButton {
    return Intl.message(
      'Delete Game',
      name: 'deleteGameButton',
      desc: 'Title for the Delete button',
    );
  }

  String get trendingTournamentsTitle {
    return Intl.message(
      'Trending Tournaments',
      name: 'trendingTournamentsTitle',
      desc: 'Title for the Trending Tournaments section',
    );
  }

  String get popularGamesTitle {
    return Intl.message(
      'Popular Games',
      name: 'popularGamesTitle',
      desc: 'Title for the Popular Games section',
    );
  }

  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: 'Title for the View All button',
    );
  }

  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: 'Title for editing the profile',
    );
  }

  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: 'Button text to save changes',
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'Button text to cancel changes',
    );
  }

  String get dangerZone {
    return Intl.message(
      'Danger Zone',
      name: 'dangerZone',
      desc: 'Title for the danger zone section',
    );
  }

  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: 'Button text to logout',
    );
  }

  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: 'Button text to delete account',
    );
  }

  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: 'Button text to confirm action',
    );
  }

  String get cancelEditing {
    return Intl.message(
      'Cancel Editing',
      name: 'cancelEditing',
      desc: 'Button text to cancel editing',
    );
  }

  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirmation',
      desc: 'Confirmation message for logout',
    );
  }

  String get deleteAccountConfirmation {
    return Intl.message(
      'Are you sure you want to delete your account? This action cannot be undone.',
      name: 'deleteAccountConfirmation',
      desc: 'Confirmation message for account deletion',
    );
  }

  String get profileUpdated {
    return Intl.message(
      'Profile updated successfully',
      name: 'profileUpdated',
      desc: 'Profile updated success message',
    );
  }

  String get errorSavingProfile {
    return Intl.message(
      'Error saving profile',
      name: 'errorSavingProfile',
      desc: 'Error message when saving profile fails',
    );
  }

  String get photoLibrary {
    return Intl.message(
      'Photo Library',
      name: 'photoLibrary',
      desc: 'Option text for selecting photo library',
    );
  }

  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: 'Option text for selecting camera',
    );
  }

  String get errorPickingImage {
    return Intl.message(
      'Error picking image',
      name: 'errorPickingImage',
      desc: 'Error message when picking image fails',
    );
  }

  String get errorUploadingProfileImage {
    return Intl.message(
      'Error uploading profile image',
      name: 'errorUploadingProfileImage',
      desc: 'Error message when uploading profile image fails',
    );
  }

  String get errorDeletingAccount {
    return Intl.message(
      'Error deleting account',
      name: 'errorDeletingAccount',
      desc: 'Error message when deleting account fails',
    );
  }

  String filters(int count) {
    return Intl.message(
      'Filters ($count)',
      name: 'filters',
      desc: 'Filter button text with count',
      args: [count],
    );
  }

  String get filterAndSort {
    return Intl.message(
      'Filter and Sort',
      name: 'filterAndSort',
      desc: 'Filter and sort title',
    );
  }

  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: 'Reset button text',
    );
  }

  String get searchTags {
    return Intl.message(
      'Search tags',
      name: 'searchTags',
      desc: 'Search tags placeholder',
    );
  }

  String get filterByTags {
    return Intl.message(
      'FILTER BY TAGS',
      name: 'filterByTags',
      desc: 'Filter by tags title',
    );
  }

  String get sort {
    return Intl.message(
      'SORT',
      name: 'sort',
      desc: 'Sort title',
    );
  }

  String get applyFilters {
    return Intl.message(
      'Apply Filters',
      name: 'applyFilters',
      desc: 'Apply filters button text',
    );
  }

  String get alphabeticalAZ {
    return Intl.message(
      'Alphabetical (A-Z)',
      name: 'alphabeticalAZ',
      desc: 'Sort option for A-Z',
    );
  }

  String get alphabeticalZA {
    return Intl.message(
      'Alphabetical (Z-A)',
      name: 'alphabeticalZA',
      desc: 'Sort option for Z-A',
    );
  }

  String get anErrorOccurred {
    return Intl.message(
      'An error occurred!',
      name: 'anErrorOccurred',
      desc: 'Error message',
    );
  }

  String get noGamesAvailable {
    return Intl.message(
      'No games available.',
      name: 'noGamesAvailable',
      desc: 'Message when no games are available',
    );
  }

  String moreTagsCount(int count) {
    return Intl.message(
      '+$count more',
      name: 'moreTagsCount',
      desc: 'More tags count',
      args: [count],
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
