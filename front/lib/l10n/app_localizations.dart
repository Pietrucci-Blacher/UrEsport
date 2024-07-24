import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:uresport/generated/l10n/intl/messages_all.dart';

class AppLocalizations {

  static Future<AppLocalizations> load(Locale locale) async {
    final String name = locale.countryCode?.isEmpty ?? false
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    debugPrint('Attempting to load localization for locale: $localeName');

    try {
      await initializeMessages(localeName);
      debugPrint('Localization for $localeName loaded successfully.');
    } catch (e) {
      debugPrint('Error loading messages for locale $localeName: $e');
    }

    Intl.defaultLocale = localeName;
    debugPrint('Default locale set to $localeName');
    return AppLocalizations();
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

  String get profileScreenWelcome {
    return Intl.message(
      'Welcome to your profile!',
      name: 'profileScreenWelcome',
      desc: 'Welcome message for the profile screen',
    );
  }

  String get verificationCodeSent {
    return Intl.message(
      'A verification code has been sent to your email.',
      name: 'verificationCodeSent',
      desc: 'Verification code sent message',
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

  String get filters {
    return Intl.message(
      'Filters',
      name: 'filters',
      desc: 'Filter button text',
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

  String get moreTagsCount {
    return Intl.message(
      'moreTagsCount',
      name: 'moreTagsCount',
      desc: 'More tags',
    );
  }

  String get mustBeLoggedIn {
    return Intl.message(
      'You must be logged in to view your tournaments',
      name: 'mustBeLoggedIn',
      desc: 'Message when no tournaments are available',
    );
  }

  String get listAllTournaments {
    return Intl.message(
      'List Tournaments',
      name: 'listAllTournaments',
      desc: 'List Tournaments button text',
    );
  }

  String get listMyTournaments {
    return Intl.message(
      'My Tournaments',
      name: 'listMyTournaments',
      desc: 'My Tournaments button text',
    );
  }

  String get listMyTeamsJoined {
    return Intl.message(
      'My Teams',
      name: 'listMyTeamsJoined',
      desc: 'My Teams button text',
    );
  }

  String get profileTab {
    return Intl.message(
      'Profile',
      name: 'profileTab',
      desc: 'Profile tab text',
    );
  }

  String get likedGamesTab {
    return Intl.message(
      'Liked Games',
      name: 'likedGamesTab',
      desc: 'Liked Games tab text',
    );
  }

  String get errorFetchingLikedGames {
    return Intl.message(
      'Error fetching liked games',
      name: 'errorFetchingLikedGames',
      desc: 'Error message when fetching liked games fails',
    );
  }

  String get noLikedGames {
    return Intl.message(
      'No liked games',
      name: 'noLikedGames',
      desc: 'Message when no liked games are available',
    );
  }

  String get failedToLoadUserTeams {
    return Intl.message(
      'Failed to load user teams',
      name: 'failedToLoadUserTeams',
      desc: 'Message displayed when user teams fail to load',
    );
  }

  String get noTeamsFoundForUser {
    return Intl.message(
      'No teams found for the user',
      name: 'noTeamsFoundForUser',
      desc: 'Message displayed when no teams are found for the user',
    );
  }

  String get membersInTeam {
    return Intl.message(
      'Members',
      name: 'membersInTeam',
      desc: 'Members count display',
    );
  }

  String get tournamentsInTeam {
    return Intl.message(
      'Tournaments',
      name: 'tournamentsInTeam',
      desc: 'Tournaments count display',
    );
  }

  String get confirmAction {
    return Intl.message(
      'Confirm Action',
      name: 'confirmAction',
      desc: 'Confirm action dialog title',
    );
  }

  String get deleteTeamConfirmation {
    return Intl.message(
      'Are you sure you want to delete the team',
      name: 'deleteTeamConfirmation',
      desc: 'Delete team confirmation message',
    );
  }

  String get leaveTeamConfirmation {
    return Intl.message(
      'Are you sure you want to leave the team',
      name: 'leaveTeamConfirmation',
      desc: 'Leave team confirmation message',
    );
  }

  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: 'Delete button text',
    );
  }

  String get leave {
    return Intl.message(
      'Leave',
      name: 'leave',
      desc: 'Leave button text',
    );
  }

  String get teamDeleted {
    return Intl.message(
      'Team deleted successfully',
      name: 'teamDeleted',
      desc: 'Team deleted success message',
    );
  }

  String get failedToDeleteTeam {
    return Intl.message(
      'Failed to delete the team',
      name: 'failedToDeleteTeam',
      desc: 'Failed to delete team message',
    );
  }

  String get teamLeft {
    return Intl.message(
      'You have left the team',
      name: 'teamLeft',
      desc: 'Team left success message',
    );
  }

  String get failedToLeaveTeam {
    return Intl.message(
      'Failed to leave the team',
      name: 'failedToLeaveTeam',
      desc: 'Failed to leave team message',
    );
  }

  String get failedToLoadTournaments {
    return Intl.message(
      'Failed to load tournaments',
      name: 'failedToLoadTournaments',
      desc: 'Failed to load tournaments message',
    );
  }

  String get unknownState {
    return Intl.message(
      'Unknown state',
      name: 'unknownState',
      desc: 'Unknown state message',
    );
  }

  String get tournamentStartDate {
    return Intl.message(
      'Start: ',
      name: 'tournamentStartDate',
      desc: 'Tournament start date display',
    );
  }

  String get tournamentEndDate {
    return Intl.message(
      'End: ',
      name: 'tournamentEndDate',
      desc: 'Tournament end date display',
    );
  }

  String get gameName {
    return Intl.message(
      'Game: ',
      name: 'gameName',
      desc: 'Game name display',
    );
  }

  String get teamPlayersCount {
    return Intl.message(
      'Players per team',
      name: 'teamPlayersCount',
      desc: 'Team players count display',
    );
  }

  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: 'View details button text',
    );
  }

  String get errorLoadingCurrentUser {
    return Intl.message(
      'Error loading current user:',
      name: 'errorLoadingCurrentUser',
      desc: 'Error message when loading current user fails',
    );
  }

  String get errorCheckingIfUpvoted {
    return Intl.message(
      'Error checking if upvoted:',
      name: 'errorCheckingIfUpvoted',
      desc: 'Error message when checking if upvoted fails',
    );
  }

  String get errorCheckingIfJoined {
    return Intl.message(
      'Error checking if joined:',
      name: 'errorCheckingIfJoined',
      desc: 'Error message when checking if joined fails',
    );
  }

  String get errorLoadingTeams {
    return Intl.message(
      'Error loading teams:',
      name: 'errorLoadingTeams',
      desc: 'Error message when loading teams fails',
    );
  }

  String get noTeamsAvailableForUser {
    return Intl.message(
      'No teams available for the current user.',
      name: 'noTeamsAvailableForUser',
      desc: 'Message displayed when no teams are available for the user',
    );
  }

  String get selectTeamToJoin {
    return Intl.message(
      'Select a Team to Join',
      name: 'selectTeamToJoin',
      desc: 'Title for selecting a team to join',
    );
  }

  String get noTeamsAvailable {
    return Intl.message(
      'No teams available.',
      name: 'noTeamsAvailable',
      desc: 'Message displayed when no teams are available',
    );
  }

  String get selectTeamToLeave {
    return Intl.message(
      'Select a Team to Leave',
      name: 'selectTeamToLeave',
      desc: 'Title for selecting a team to leave',
    );
  }

  String get confirmLeaveTeam {
    return Intl.message(
      'You left the team',
      name: 'confirmLeaveTeam',
      desc: 'Title for confirming leave',
    );
  }

  String get confirmLeaveTournament {
    return Intl.message(
      'Are you sure you want to leave this tournament?',
      name: 'confirmLeaveTournament',
      desc: 'Message for confirming leave tournament',
    );
  }

  String get mustBeLoggedInToUpvote {
    return Intl.message(
      'You must be logged in to upvote',
      name: 'mustBeLoggedInToUpvote',
      desc: 'Message displayed when user must be logged in to upvote',
    );
  }

  String get upvoteAdded {
    return Intl.message(
      'Upvote added',
      name: 'upvoteAdded',
      desc: 'Message displayed when upvote is added',
    );
  }

  String get upvoteRemoved {
    return Intl.message(
      'Upvote retiré',
      name: 'upvoteRemoved',
      desc: 'Message displayed when upvote is removed',
    );
  }

  String get failedToChangeUpvoteStatus {
    return Intl.message(
      'Failed to change upvote status',
      name: 'failedToChangeUpvoteStatus',
      desc: 'Message displayed when upvote status change fails',
    );
  }

  String get leftTournament {
    return Intl.message(
      'You have left the tournament',
      name: 'leftTournament',
      desc: 'Message displayed when user leaves tournament',
    );
  }

  String get teamNotRegistered {
    return Intl.message(
      'Cette team n\'est pas inscrite dans le tournoi',
      name: 'teamNotRegistered',
      desc: 'Message displayed when team is not registered in the tournament',
    );
  }

  String get resourceNotFound404 {
    return Intl.message(
      'Ressource non trouvée (404)',
      name: 'resourceNotFound404',
      desc: 'Message displayed when resource is not found (404)',
    );
  }

  String get leaveTournamentError {
    return Intl.message(
      'Erreur pour quitter le tournoi',
      name: 'leaveTournamentError',
      desc:
          'Message displayed when an unknown error occurs while leaving the tournament',
    );
  }

  String get unknownError {
    return Intl.message(
      'Erreur inconnue',
      name: 'unknownError',
      desc: 'Message displayed when an unknown error occurs',
    );
  }

  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: 'Details tab text',
    );
  }

  String get bracket {
    return Intl.message(
      'Bracket',
      name: 'bracket',
      desc: 'Bracket tab text',
    );
  }

  String get mustBeLoggedInToViewBracket {
    return Intl.message(
      'You must be logged in to view your bracket',
      name: 'mustBeLoggedInToViewBracket',
      desc: 'Message displayed when user must be logged in to view bracket',
    );
  }

  String get description {
    return Intl.message(
      'Description:',
      name: 'description',
      desc: 'Description label text',
    );
  }

  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: 'Location label text',
    );
  }

  String get game {
    return Intl.message(
      'Game:',
      name: 'game',
      desc: 'Game label text',
    );
  }

  String get startDateText {
    return Intl.message(
      'Start Date: ',
      name: 'startDateText',
      desc: 'Start date label text',
    );
  }

  String get endDateText {
    return Intl.message(
      'End Date:',
      name: 'endDate',
      desc: 'End date display text',
    );
  }

  /*String get locationText {
    return Intl.message(
      'Location:',
      name: 'locationText',
      desc: 'Location display text',
    );
  }*/

  String get startDate {
    return Intl.message(
      'Start: ',
      name: 'startDate',
      desc: 'Start date display text',
    );
  }

  String get endDate {
    return Intl.message(
      'End:',
      name: 'endDate',
      desc: 'End date display text',
    );
  }

  String get upvotes {
    return Intl.message(
      'Upvotes:',
      name: 'upvotes',
      desc: 'Upvotes label text',
    );
  }

  String get participants {
    return Intl.message(
      'Participants:',
      name: 'participants',
      desc: 'Participants label text',
    );
  }

  String get viewAllParticipants {
    return Intl.message(
      'View all participants',
      name: 'viewAllParticipants',
      desc: 'View all participants text',
    );
  }

  String get generateBracket {
    return Intl.message(
      'Generate Bracket',
      name: 'generateBracket',
      desc: 'Generate bracket button text',
    );
  }

  String get joinTournament {
    return Intl.message(
      'Join Tournament',
      name: 'joinTournament',
      desc: 'Join tournament button text',
    );
  }

  String get leaveTournament {
    return Intl.message(
      'Leave Tournament',
      name: 'leaveTournament',
      desc: 'Leave tournament button text',
    );
  }

  String get joinedTournament {
    return Intl.message(
      'You have successfully joined the tournament',
      name: 'joinedTournament',
      desc: 'Message displayed when user joins tournament successfully',
    );
  }

  String get teamAlreadyInTournament {
    return Intl.message(
      'Team already in this tournament',
      name: 'teamAlreadyInTournament',
      desc: 'Message displayed when team is already in the tournament',
    );
  }

  String get alreadyJoinedTournament {
    return Intl.message(
      'You have already joined this tournament',
      name: 'alreadyJoinedTournament',
      desc: 'Message displayed when user has already joined the tournament',
    );
  }

  String get joinError {
    return Intl.message(
      'Error to joining',
      name: 'joinError',
      desc: 'Message displayed when an unknown error occurs while joining the tournament',
    );
  }

  String get unknownJoinError {
    return Intl.message(
      'Unknown error joining tournament',
      name: 'unknownJoinError',
      desc:
          'Message displayed when an unknown error occurs while joining the tournament',
    );
  }

  String get tournamentParticipants {
    return Intl.message(
      'Tournament participants',
      name: 'tournamentParticipants',
      desc: 'Title for the tournament participants screen',
    );
  }

  String get editTournament {
    return Intl.message(
      'Edit Tournament',
      name: 'editTournament',
      desc: 'Title for the edit tournament screen',
    );
  }

  String get tournamentUpdatedSuccessfully {
    return Intl.message(
      'Tournament updated successfully',
      name: 'tournamentUpdatedSuccessfully',
      desc: 'Message displayed when the tournament is updated successfully',
    );
  }

  String get failedToUpdateTournament {
    return Intl.message(
      'Failed to update tournament',
      name: 'failedToUpdateTournament',
      desc: 'Message displayed when the tournament update fails',
    );
  }

  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: 'Label for the name field',
    );
  }

  String get pleaseEnterName {
    return Intl.message(
      'Please enter a name',
      name: 'pleaseEnterName',
      desc: 'Validation message for the name field',
    );
  }

  String get pleaseEnterDescription {
    return Intl.message(
      'Please enter a description',
      name: 'pleaseEnterDescription',
      desc: 'Validation message for the description field',
    );
  }

  String get pleaseEnterStartDate {
    return Intl.message(
      'Please enter a start date',
      name: 'pleaseEnterStartDate',
      desc: 'Validation message for the start date field',
    );
  }

  String get pleaseEnterEndDate {
    return Intl.message(
      'Please enter an end date',
      name: 'pleaseEnterEndDate',
      desc: 'Validation message for the end date field',
    );
  }

  String get pleaseEnterLocation {
    return Intl.message(
      'Please enter a location',
      name: 'pleaseEnterLocation',
      desc: 'Validation message for the location field',
    );
  }

  String get latitude {
    return Intl.message(
      'Latitude',
      name: 'latitude',
      desc: 'Label for the latitude field',
    );
  }

  String get pleaseEnterLatitude {
    return Intl.message(
      'Please enter a latitude',
      name: 'pleaseEnterLatitude',
      desc: 'Validation message for the latitude field',
    );
  }

  String get longitude {
    return Intl.message(
      'Longitude',
      name: 'longitude',
      desc: 'Label for the longitude field',
    );
  }

  String get pleaseEnterLongitude {
    return Intl.message(
      'Please enter a longitude',
      name: 'pleaseEnterLongitude',
      desc: 'Validation message for the longitude field',
    );
  }

  String get imageUrl {
    return Intl.message(
      'Image URL',
      name: 'imageUrl',
      desc: 'Label for the image URL field',
    );
  }

  String get pleaseEnterImageUrl {
    return Intl.message(
      'Please enter an image URL',
      name: 'pleaseEnterImageUrl',
      desc: 'Validation message for the image URL field',
    );
  }

  String get private {
    return Intl.message(
      'Private',
      name: 'private',
      desc: 'Label for the private switch',
    );
  }

  String get gameId {
    return Intl.message(
      'Game',
      name: 'gameId',
      desc: 'Label for the game ID field',
    );
  }

  String get pleaseEnterGameId {
    return Intl.message(
      'Please enter a game',
      name: 'pleaseEnterGameId',
      desc: 'Validation message for the game ID field',
    );
  }

  String get numberOfPlayers {
    return Intl.message(
      'Number of Players',
      name: 'numberOfPlayers',
      desc: 'Label for the number of players field',
    );
  }

  String get pleaseEnterNumberOfPlayers {
    return Intl.message(
      'Please enter the number of players',
      name: 'pleaseEnterNumberOfPlayers',
      desc: 'Validation message for the number of players field',
    );
  }

  String get validate {
    return Intl.message(
      'Validate',
      name: 'validate',
      desc: 'Text for the validate button',
    );
  }

  String get addTournament {
    return Intl.message(
      'Add Tournament',
      name: 'addTournament',
      desc: 'Title for the add tournament screen',
    );
  }

  String get tournamentCreatedSuccessfully {
    return Intl.message(
      'Tournoi créé avec succès',
      name: 'tournamentCreatedSuccessfully',
      desc: 'Message displayed when the tournament is created successfully',
    );
  }

  String get failedToCreateTournament {
    return Intl.message(
      'Erreur lors de la création du tournoi',
      name: 'failedToCreateTournament',
      desc: 'Message displayed when the tournament creation fails',
    );
  }

  String get nameIsRequired {
    return Intl.message(
      'Name is required',
      name: 'nameIsRequired',
      desc: 'Validation message for the name field',
    );
  }

  String get descriptionIsRequired {
    return Intl.message(
      'Description is required',
      name: 'descriptionIsRequired',
      desc: 'Validation message for the description field',
    );
  }

  String get startDateIsRequired {
    return Intl.message(
      'Start Date is required',
      name: 'startDateIsRequired',
      desc: 'Validation message for the start date field',
    );
  }

  String get endDateIsRequired {
    return Intl.message(
      'End Date is required',
      name: 'endDateIsRequired',
      desc: 'Validation message for the end date field',
    );
  }

  String get gameIdIsRequired {
    return Intl.message(
      'Game is required',
      name: 'gameIdIsRequired',
      desc: 'Validation message for the game ID field',
    );
  }

  String get numberOfPlayersPerTeam {
    return Intl.message(
      'Number of Players per Team',
      name: 'numberOfPlayersPerTeam',
      desc: 'Label for the number of players per team field',
    );
  }

  String get numberOfPlayersIsRequired {
    return Intl.message(
      'Number of Players is required',
      name: 'numberOfPlayersIsRequired',
      desc: 'Validation message for the number of players field',
    );
  }

  String get createTournament {
    return Intl.message(
      'Create Tournament',
      name: 'createTournament',
      desc: 'Text for the create tournament button',
    );
  }

  String get errorLoadingTournaments {
    return Intl.message(
      'Error loading tournaments',
      name: 'errorLoadingTournaments',
      desc: 'Error message when loading tournaments fails',
    );
  }

  String get confirmKick {
    return Intl.message(
      'Confirm Kick',
      name: 'confirmKick',
      desc: 'Title for the confirm kick dialog',
    );
  }

  String get confirmKickMessage {
    return Intl.message(
      'Are you sure you want to kick this user from the team',
      name: 'confirmKickMessage',
      desc: 'Message for the confirm kick dialog',
    );
  }

  String get kick {
    return Intl.message(
      'Kick',
      name: 'kick',
      desc: 'Kick button text',
    );
  }

  String get membersOfTeam {
    return Intl.message(
      'Members of the team',
      name: 'membersOfTeam',
      desc: 'Title for the team members screen',
    );
  }

  String get userKickedSuccess {
    return Intl.message(
      'User kicked successfully',
      name: 'userKickedSuccess',
      desc: 'Message displayed when a user is kicked successfully',
    );
  }

  String get errorKickingUser {
    return Intl.message(
      'Error kicking user',
      name: 'errorKickingUser',
      desc: 'Error message when kicking a user fails',
    );
  }

  String get addTeam {
    return Intl.message(
      'Add Team',
      name: 'addTeam',
      desc: 'Title for the add team screen',
    );
  }

  String get teamCreatedSuccessfully {
    return Intl.message(
      'Team created successfully',
      name: 'teamCreatedSuccessfully',
      desc: 'Message displayed when the team is created successfully',
    );
  }

  String get failedToCreateTeam {
    return Intl.message(
      'Failed to create team',
      name: 'failedToCreateTeam',
      desc: 'Message displayed when the team creation fails',
    );
  }

  String get createTeam {
    return Intl.message(
      'Create Team',
      name: 'createTeam',
      desc: 'Text for the create team button',
    );
  }

  String get noRatingFetched {
    return Intl.message(
      'No rating fetched',
      name: 'noRatingFetched',
      desc: 'Message displayed when no rating is fetched',
    );
  }

  String get ratingFetchedSuccessfully {
    return Intl.message(
      'Rating fetched successfully',
      name: 'ratingFetchedSuccessfully',
      desc: 'Message displayed when the rating is fetched successfully',
    );
  }

  String get errorFetchingRating {
    return Intl.message(
      'Error fetching rating',
      name: 'errorFetchingRating',
      desc: 'Error message when fetching rating fails',
    );
  }

  String get ratingCannotBeZero {
    return Intl.message(
      'Rating cannot be zero',
      name: 'ratingCannotBeZero',
      desc: 'Message displayed when the rating cannot be zero',
    );
  }

  String get ratingSavedSuccessfully {
    return Intl.message(
      'Rating saved successfully',
      name: 'ratingSavedSuccessfully',
      desc: 'Message displayed when the rating is saved successfully',
    );
  }

  String get errorSavingRating {
    return Intl.message(
      'Error saving rating',
      name: 'errorSavingRating',
      desc: 'Error message when saving rating fails',
    );
  }

  String get yourRating {
    return Intl.message(
      'Your Rating:',
      name: 'yourRating',
      desc: 'Label for the user rating',
    );
  }

  String get tournaments {
    return Intl.message(
      'Tournaments',
      name: 'tournaments',
      desc: 'Title for the tournaments screen',
    );
  }

  String get customBracket {
    return Intl.message(
      'Custom Bracket',
      name: 'customBracket',
      desc: 'Label for the custom bracket button',
    );
  }

  String get customPoules {
    return Intl.message(
      'Custom Poules',
      name: 'customPoules',
      desc: 'Label for the custom poules button',
    );
  }

  String get failedToLoadUsers {
    return Intl.message(
      'Failed to load users',
      name: 'failedToLoadUsers',
      desc: 'Error message when loading users fails',
    );
  }

  String get noUsersFound {
    return Intl.message(
      'No users found',
      name: 'noUsersFound',
      desc: 'Message displayed when no users are found',
    );
  }

  String get viewGames {
    return Intl.message(
      'View Games',
      name: 'viewGames',
      desc: 'Button text to view games',
    );
  }

  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: 'Tab title for notifications',
    );
  }

  String get friends {
    return Intl.message(
      'Friends',
      name: 'friends',
      desc: 'Tab title for friends',
    );
  }

  String get notificationDeleted {
    return Intl.message(
      'Notification supprimée',
      name: 'notificationDeleted',
      desc: 'Message displayed when a notification is deleted',
    );
  }

  String get addFriend {
    return Intl.message(
      'Add Friend',
      name: 'addFriend',
      desc: 'Title for the add friend page',
    );
  }

  String get searchUser {
    return Intl.message(
      'Search User',
      name: 'searchUser',
      desc: 'Label for the search user text field',
    );
  }

  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: 'Label for unknown user',
    );
  }

  String get friendAddedSuccessfully {
    return Intl.message(
      'Friend added successfully',
      name: 'friendAddedSuccessfully',
      desc: 'Notification message when a friend is added successfully',
    );
  }

  String get friendAlreadyAdded {
    return Intl.message(
      'Friend already added',
      name: 'friendAlreadyAdded',
      desc: 'Error message when the friend is already added',
    );
  }

  String get errorAddingFriend {
    return Intl.message(
      'Error adding friend',
      name: 'errorAddingFriend',
      desc: 'Error message when there is an error adding a friend',
    );
  }

  String get friendDetails {
    return Intl.message(
      'Friend Details',
      name: 'friendDetails',
      desc: 'Title for the friend details page',
    );
  }

  String get friendsTab {
    return Intl.message(
      'Amis',
      name: 'friendsTab',
      desc: 'Tab title for friends',
    );
  }

  String get sortAToZ {
    return Intl.message(
      'Trier A-Z',
      name: 'sortAToZ',
      desc: 'Button text to sort friends from A to Z',
    );
  }

  String get sortZToA {
    return Intl.message(
      'Trier Z-A',
      name: 'sortZToA',
      desc: 'Button text to sort friends from Z to A',
    );
  }

  String get noFriendsFound {
    return Intl.message(
      'No friends found',
      name: 'noFriendsFound',
      desc: 'Message displayed when no friends are found',
    );
  }

  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: 'Section title for favorite friends',
    );
  }

  String get confirmDeleteFriend {
    return Intl.message(
      'Are you sure you want to delete this friend',
      name: 'confirmDeleteFriend',
      desc: 'Confirmation message to delete a friend',
    );
  }

  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: 'Text for no button',
    );
  }

  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: 'Text for yes button',
    );
  }

  String get failedToLoadFriends {
    return Intl.message(
      'Failed to load friends',
      name: 'failedToLoadFriends',
      desc: 'Error message when loading friends fails',
    );
  }

  String get failedToUpdateFavoriteStatus {
    return Intl.message(
      'Failed to update favorite status',
      name: 'failedToUpdateFavoriteStatus',
      desc: 'Error message when updating favorite status fails',
    );
  }

  String get failedToDeleteFriend {
    return Intl.message(
      'Failed to delete friend',
      name: 'failedToDeleteFriend',
      desc: 'Error message when deleting a friend fails',
    );
  }

  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: 'Text displayed while loading',
    );
  }

  String get bracketUpdated {
    return Intl.message(
      'Bracket updated',
      name: 'bracketUpdated',
      desc: 'Text displayed when the bracket is updated',
    );
  }

  String get failedToLoadBracket {
    return Intl.message(
      'Failed to load bracket',
      name: 'failedToLoadBracket',
      desc: 'Error message when loading the bracket fails',
    );
  }

  String get waiting {
    return Intl.message(
      'waiting',
      name: 'waiting',
      desc: 'Text displayed when a team is waiting',
    );
  }

  String get poulesTitle {
    return Intl.message(
      'Tournament Pools',
      name: 'poulesTitle',
      desc: 'Title for the poules page',
    );
  }

  String get viewBrackets {
    return Intl.message(
      'View Brackets',
      name: 'viewBrackets',
      desc: 'Button text to view the brackets',
    );
  }

  String get team {
    return Intl.message(
      'Team',
      name: 'team',
      desc: 'Table header for team names',
    );
  }

  String get score {
    return Intl.message(
      'Score',
      name: 'score',
      desc: 'Table header for team scores',
    );
  }

  String get matchDetails {
    return Intl.message(
      'Match Details',
      name: 'matchDetails',
      desc: 'Title for the match details page',
    );
  }

  String get updateScore {
    return Intl.message(
      'Update Score',
      name: 'updateScore',
      desc: 'Button text to update the score',
    );
  }

  String get closeMatch {
    return Intl.message(
      'Close Match',
      name: 'closeMatch',
      desc: 'Button text to close the match',
    );
  }

  String get cancelClose {
    return Intl.message(
      'Cancel Close',
      name: 'cancelClose',
      desc: 'Button text to cancel the close of the match',
    );
  }

  String get updateMatch {
    return Intl.message(
      'Update Match',
      name: 'updateMatch',
      desc: 'Button text to update the match',
    );
  }

  String get proposeToClose {
    return Intl.message(
      'Propose to close',
      name: 'proposeToClose',
      desc: 'Text indicating a team proposes to close the match',
    );
  }

  String get noWinnerYet {
    return Intl.message(
      'No winner yet',
      name: 'noWinnerYet',
      desc: 'Text indicating no winner has been determined yet',
    );
  }

  String get cancelCloseMatch {
    return Intl.message(
      'Cancel Close Match',
      name: 'cancelCloseMatch',
      desc: 'Button text for canceling the closure of the match',
    );
  }

  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: 'Label for status',
    );
  }

  String get winner {
    return Intl.message(
      'Winner',
      name: 'winner',
      desc: 'Label for winner',
    );
  }

  String get team1Score {
    return Intl.message(
      'Team 1 Score',
      name: 'team1Score',
      desc: 'Label for team 1 score',
    );
  }

  String get team2Score {
    return Intl.message(
      'Team 2 Score',
      name: 'team2Score',
      desc: 'Label for team 2 score',
    );
  }

  String get pouleBrackets {
    return Intl.message(
      'Poule Brackets',
      name: 'pouleBrackets',
      desc: 'Title for the poule brackets page',
    );
  }

  String get enterResult {
    return Intl.message(
      'Enter result for',
      name: 'enterResult',
      desc: 'Prompt to enter result for a match',
    );
  }

  String get vs {
    return Intl.message(
      'VS',
      name: 'vs',
      desc: 'Text for VS',
    );
  }

  String get addGame {
    return Intl.message(
      'Add Game',
      name: 'addGame',
      desc: 'Title for the add game dialog',
    );
  }

  String get tags {
    return Intl.message(
      'Tags',
      name: 'tags',
      desc: 'Label for the tags field',
    );
  }

  String get pleaseEnterGameName {
    return Intl.message(
      'Please enter the game name',
      name: 'pleaseEnterGameName',
      desc: 'Validation message for the game name field',
    );
  }

  String get pleaseEnterGameDescription {
    return Intl.message(
      'Please enter the game description',
      name: 'pleaseEnterGameDescription',
      desc: 'Validation message for the game description field',
    );
  }

  String get pleaseEnterTags {
    return Intl.message(
      'Please enter the tags',
      name: 'pleaseEnterTags',
      desc: 'Validation message for the tags field',
    );
  }

  String get gameAdded {
    return Intl.message(
      'Game added',
      name: 'gameAdded',
      desc: 'Message for game added',
    );
  }

  String get errorAddingGame {
    return Intl.message(
      'Error adding game',
      name: 'errorAddingGame',
      desc: 'Message for error adding game',
    );
  }

  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: 'OK button text',
    );
  }

  String get startDateTime {
    return Intl.message(
      'Start Date & Time',
      name: 'startDateTime',
      desc: 'Label for the start date and time field',
    );
  }

  String get endDateTime {
    return Intl.message(
      'End Date & Time',
      name: 'endDateTime',
      desc: 'Label for the end date and time field',
    );
  }

  String get pleaseEnterTournamentName {
    return Intl.message(
      'Please enter the tournament name',
      name: 'pleaseEnterTournamentName',
      desc: 'Validation message for the tournament name field',
    );
  }

  String get pleaseEnterTournamentDescription {
    return Intl.message(
      'Please enter the tournament description',
      name: 'pleaseEnterTournamentDescription',
      desc: 'Validation message for the tournament description field',
    );
  }

  String get pleaseEnterIfTournamentIsPrivate {
    return Intl.message(
      'Please enter if the tournament is private',
      name: 'pleaseEnterIfTournamentIsPrivate',
      desc: 'Validation message for the private field',
    );
  }

  String get tournamentAdded {
    return Intl.message(
      'Tournament added',
      name: 'tournamentAdded',
      desc: 'Message for tournament added',
    );
  }

  String get errorAddingTournament {
    return Intl.message(
      'Error adding tournament',
      name: 'errorAddingTournament',
      desc: 'Message for error adding tournament',
    );
  }

  String get selectStartDate {
    return Intl.message(
      'Select Start Date',
      name: 'selectStartDate',
      desc: 'Title for select start date dialog',
    );
  }

  String get selectEndDate {
    return Intl.message(
      'Select End Date',
      name: 'selectEndDate',
      desc: 'Title for select end date dialog',
    );
  }

  String get pleaseFillRequiredFields {
    return Intl.message(
      'Please fill in all required fields and select dates and times',
      name: 'pleaseFillRequiredFields',
      desc: 'Validation message for required fields and dates',
    );
  }

  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: 'Label for the dashboard navigation item',
    );
  }

  String get logs {
    return Intl.message(
      'Logs',
      name: 'logs',
      desc: 'Label for the logs navigation item',
    );
  }

  String get games {
    return Intl.message(
      'Games',
      name: 'games',
      desc: 'Label for the games navigation item',
    );
  }

  String get users {
    return Intl.message(
      'Users',
      name: 'users',
      desc: 'Label for the users navigation item',
    );
  }

  String get activeUsers {
    return Intl.message(
      'Active Users',
      name: 'activeUsers',
      desc: 'Label for active users',
    );
  }

  String get activeTournaments {
    return Intl.message(
      'Active Tournaments',
      name: 'activeTournaments',
      desc: 'Label for active tournaments',
    );
  }

  String get totalGames {
    return Intl.message(
      'Total Games',
      name: 'totalGames',
      desc: 'Label for total games',
    );
  }

  String get latestMessage {
    return Intl.message(
      'Latest Message',
      name: 'latestMessage',
      desc: 'Label for the latest message',
    );
  }

  String get deleteGame {
    return Intl.message(
      'Delete Game',
      name: 'deleteGame',
      desc: 'Title for the delete game confirmation dialog',
    );
  }

  String get confirmDeleteGame {
    return Intl.message(
      'Are you sure you want to delete this game?',
      name: 'confirmDeleteGame',
      desc: 'Confirmation message for deleting a game',
    );
  }

  String get unknownPage {
    return Intl.message(
      'Unknown page',
      name: 'unknownPage',
      desc: 'Label for unknown page',
    );
  }

  String get errorLoading {
    return Intl.message(
      'Error loading data',
      name: 'errorLoading',
      desc: 'Label for error loading data',
    );
  }

  String get descriptionGame {
    return Intl.message(
      'Description:',
      name: 'descriptionGame',
      desc: 'Description label text',
    );
  }

  String get gameDetailPageTitle {
    return Intl.message(
      'Game Details',
      name: 'gameDetailPageTitle',
      desc: 'Title for the game details page',
    );
  }

  String get youMustBeLoggedIn {
    return Intl.message(
      'You must be logged in to follow this game',
      name: 'youMustBeLoggedIn',
      desc:
          'Message shown when user tries to like a game without being logged in',
    );
  }

  String get addedToGameList {
    return Intl.message(
      'Game added to your list',
      name: 'addedToGameList',
      desc: 'Message shown when game is added to user\'s list',
    );
  }

  String get errorFollowingGame {
    return Intl.message(
      'Error following the game',
      name: 'errorFollowingGame',
      desc: 'Message shown when there is an error following the game',
    );
  }

  String get removedFromGameList {
    return Intl.message(
      'Game removed from your list',
      name: 'removedFromGameList',
      desc: 'Message shown when game is removed from user\'s list',
    );
  }

  String get noLikeToDelete {
    return Intl.message(
      'No like to delete',
      name: 'noLikeToDelete',
      desc: 'Message shown when there is no like to delete',
    );
  }

  String get errorUnfollowingGame {
    return Intl.message(
      'Error unfollowing the game',
      name: 'errorUnfollowingGame',
      desc: 'Message shown when there is an error unfollowing the game',
    );
  }

  String get gameDescription {
    return Intl.message(
      'Game Description',
      name: 'gameDescription',
      desc: 'Title for the game description section',
    );
  }

  String get noTournamentsForGame {
    return Intl.message(
      'No tournaments for this game',
      name: 'noTournamentsForGame',
      desc: 'Message shown when there are no tournaments for the game',
    );
  }

  String get noTournamentsFound {
    return Intl.message(
      'No tournaments found',
      name: 'noTournamentsFound',
      desc: 'Message shown when no tournaments are found',
    );
  }

  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: 'Label for the start date',
    );
  }

  String get end {
    return Intl.message(
      'End',
      name: 'end',
      desc: 'Label for the end date',
    );
  }

  String get noJoinedTournaments {
    return Intl.message(
      'No joined tournaments',
      name: 'noJoinedTournaments',
      desc: 'Message shown when user has not joined any tournaments',
    );
  }

  String get failedToLoadGames {
    return Intl.message(
      'Failed to load games',
      name: 'failedToLoadGames',
      desc: 'Message shown when loading games fails',
    );
  }

  String get selectGame {
    return Intl.message(
      'Select Game',
      name: 'selectGame',
      desc: 'Title for the select game dialog',
    );
  }

  String get tournamentText {
    return Intl.message(
      'Tournaments',
      name: 'tournamentText',
      desc: 'Label for the tournament field',
    );
  }

  String get nothingTournamentforGame {
    return Intl.message(
      'No tournaments for this game',
      name: 'nothingTournamentforGame',
      desc: 'Message displayed when no tournament is available for the game',
    );
  }

  String get profileImageUpdated {
    return Intl.message(
      'Profile image updated',
      name: 'profileImageUpdated',
      desc: 'Message shown when the profile image is updated',
    );
  }

  String get removedFromLikedGames {
    return Intl.message(
      'Removed from liked games',
      name: 'removedFromLikedGames',
      desc: 'Message shown when a game is removed from liked games',
    );
  }

  String get needConnected {
    return Intl.message(
      'You must be logged in to access this page',
      name: 'needConnected',
      desc: 'Message shown when user is not connected',
    );
  }

  String get changeImage {
    return Intl.message(
      'Change Image',
      name: 'changeImage',
      desc: 'Button text to change image',
    );
  }

  String get tournamentSchedule {
    return Intl.message(
      'Tournament Schedule',
      name: 'tournamentSchedule',
      desc: 'Title for the tournament schedule page',
    );
  }

  String get allTournaments {
    return Intl.message(
      'All Tournaments',
      name: 'allTournaments',
      desc: 'Title for the all tournaments page',
    );
  }

  String get nowTournaments {
    return Intl.message(
      'Now',
      name: 'nowTournaments',
      desc: 'Title for the now tournaments page',
    );
  }

  String get selectDate {
    return Intl.message(
      'Select Date',
      name: 'selectDate',
      desc: 'Title for the select date dialog',
    );
  }

  String get noTournamentForDate {
    return Intl.message(
      'No tournament for this date',
      name: 'noTournamentForDate',
      desc: 'Message shown when there are no tournaments now',
    );
  }

  String get myTeams {
    return Intl.message(
      'My Teams',
      name: 'myTeams',
      desc: 'Title for the my teams page',
    );
  }

  String get userIsNotLogin {
    return Intl.message(
      'User is not logged in',
      name: 'userIsNotLogin',
      desc: 'Message shown when user is not login',
    );
  }

  String get accessDeniedMessage {
    return Intl.message(
      'Sorry, you do not have permission to access this page.',
      name: 'accessDeniedMessage',
      desc: 'Message shown when user is not authorized to access the page',
    );
  }

  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: 'Text for back button',
    );
  }

  String get svgLoadError {
    return Intl.message(
      'Error loading SVG',
      name: 'svgLoadError',
      desc: 'Error message when loading SVG fails',
    );
  }

  String get invitationSentSuccessfully {
    return Intl.message(
      'Invitation sent successfully',
      name: 'invitationSentSuccessfully',
      desc: 'Message displayed when the invitation is sent successfully',
    );
  }

  String get invitationSendError {
    return Intl.message(
      'Error sending invitation',
      name: 'invitationSendError',
      desc: 'Message displayed when the invitation send fails',
    );
  }

  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: 'Hello text',
    );
  }

  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: 'Success text',
    );
  }

  String get failure {
    return Intl.message(
      'Failure',
      name: 'failure',
      desc: 'Failure text',
    );
  }

  String get confirmLeave {
    return Intl.message(
      'Confirm Leave',
      name: 'confirmLeave',
      desc: 'Title for the confirm leave team dialog',
    );
  }

  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: 'Error text',
    );
  }

  String get loginRequiredForNotifications {
    return Intl.message(
      'You must be logged in to receive notifications',
      name: 'loginRequiredForNotifications',
      desc: 'Message shown when user is not logged in to receive notifications',
    );
  }

  String get invalidCurrentLocation {
    return Intl.message(
      'Invalid current location',
      name: 'invalidCurrentLocation',
      desc: 'Message shown when the current location is invalid',
    );
  }

  String get dataLoadFailed {
    return Intl.message(
      'Data load failed',
      name: 'dataLoadFailed',
      desc: 'Message shown when data load fails',
    );
  }

  String get noTournamentsAvailable {
    return Intl.message(
      'No tournaments available',
      name: 'noTournamentsAvailable',
      desc: 'Message shown when no tournaments are available',
    );
  }

  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: 'More text',
    );
  }

  String get loginDisabled {
    return Intl.message(
      'Login is disabled',
      name: 'loginDisabled',
      desc: 'Message indicating that the login functionality is disabled',
    );
  }

  String get registerDisabled {
    return Intl.message(
      'Register is disabled',
      name: 'registerDisabled',
      desc: 'Message indicating that the register functionality is disabled',
    );
  }

  String get generalInformation {
    return Intl.message(
      'General Information',
      name: 'generalInformation',
      desc: 'Label for general information section',
    );
  }

  String get organizer {
    return Intl.message(
      'Organizer',
      name: 'organizer',
      desc: 'Label for organizer or event planner',
    );
  }

  String get participatingTeams {
    return Intl.message(
      'Participating Teams',
      name: 'participatingTeams',
      desc: 'Label for the teams participating in a tournament or event',
    );
  }

  String get viewTournamentDetails {
    return Intl.message(
      'View Tournament Details',
      name: 'viewTournamentDetails',
      desc: 'Button text to view the details of the tournament',
    );
  }

  String get getDirections {
    return Intl.message(
      'Get Directions',
      name: 'getDirections',
      desc: 'Button text to get directions to a location',
    );
  }

  String get exportDirections {
    return Intl.message(
      'Export Directions',
      name: 'exportDirections',
      desc: 'Button text to export directions to a file or other format',
    );
  }

  String get searchForTournament {
    return Intl.message(
      'Search for a tournament',
      name: 'searchForTournament',
      desc: 'Placeholder or label text for searching for a tournament',
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