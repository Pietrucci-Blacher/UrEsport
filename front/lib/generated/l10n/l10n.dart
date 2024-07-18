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

  /// `You must be logged in to view your tournaments`
  String get mustBeLoggedIn {
    return Intl.message(
      'You must be logged in to view your tournaments',
      name: 'mustBeLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `List Tournaments`
  String get listAllTournaments {
    return Intl.message(
      'List Tournaments',
      name: 'listAllTournaments',
      desc: '',
      args: [],
    );
  }

  /// `My Tournaments`
  String get listMyTournaments {
    return Intl.message(
      'My Tournaments',
      name: 'listMyTournaments',
      desc: '',
      args: [],
    );
  }

  /// `My Teams`
  String get listMyTeamsJoined {
    return Intl.message(
      'My Teams',
      name: 'listMyTeamsJoined',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Logs`
  String get logs {
    return Intl.message(
      'Logs',
      name: 'logs',
      desc: '',
      args: [],
    );
  }

  /// `Tournaments`
  String get tournaments {
    return Intl.message(
      'Tournaments',
      name: 'tournaments',
      desc: '',
      args: [],
    );
  }

  /// `Games`
  String get games {
    return Intl.message(
      'Games',
      name: 'games',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get users {
    return Intl.message(
      'Users',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `Active Users`
  String get activeUsers {
    return Intl.message(
      'Active Users',
      name: 'activeUsers',
      desc: '',
      args: [],
    );
  }

  /// `Active Tournaments`
  String get activeTournaments {
    return Intl.message(
      'Active Tournaments',
      name: 'activeTournaments',
      desc: '',
      args: [],
    );
  }

  /// `Total Games`
  String get totalGames {
    return Intl.message(
      'Total Games',
      name: 'totalGames',
      desc: '',
      args: [],
    );
  }

  /// `Latest Message`
  String get latestMessage {
    return Intl.message(
      'Latest Message',
      name: 'latestMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete Game`
  String get deleteGame {
    return Intl.message(
      'Delete Game',
      name: 'deleteGame',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this game?`
  String get confirmDeleteGame {
    return Intl.message(
      'Are you sure you want to delete this game?',
      name: 'confirmDeleteGame',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Page`
  String get unknownPage {
    return Intl.message(
      'Unknown Page',
      name: 'unknownPage',
      desc: '',
      args: [],
    );
  }

  /// `Error loading data`
  String get errorLoading {
    return Intl.message(
      'Error loading data',
      name: 'errorLoading',
      desc: '',
      args: [],
    );
  }

  /// `Actions`
  String get actions {
    return Intl.message(
      'Actions',
      name: 'actions',
      desc: '',
      args: [],
    );
  }

  /// `Game Details`
  String get gameDetailPageTitle {
    return Intl.message(
      'Game Details',
      name: 'gameDetailPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `You must be logged in to follow this game`
  String get youMustBeLoggedIn {
    return Intl.message(
      'You must be logged in to follow this game',
      name: 'youMustBeLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Game added to your list`
  String get addedToGameList {
    return Intl.message(
      'Game added to your list',
      name: 'addedToGameList',
      desc: '',
      args: [],
    );
  }

  /// `Error following the game: {error}`
  String errorFollowingGame(Object error) {
    return Intl.message(
      'Error following the game: $error',
      name: 'errorFollowingGame',
      desc: '',
      args: [error],
    );
  }

  /// `Game removed from your list`
  String get removedFromGameList {
    return Intl.message(
      'Game removed from your list',
      name: 'removedFromGameList',
      desc: '',
      args: [],
    );
  }

  /// `No like to delete`
  String get noLikeToDelete {
    return Intl.message(
      'No like to delete',
      name: 'noLikeToDelete',
      desc: '',
      args: [],
    );
  }

  /// `Error unfollowing the game: {error}`
  String errorUnfollowingGame(Object error) {
    return Intl.message(
      'Error unfollowing the game: $error',
      name: 'errorUnfollowingGame',
      desc: '',
      args: [error],
    );
  }

  /// `Game Description`
  String get gameDescription {
    return Intl.message(
      'Game Description',
      name: 'gameDescription',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get tags {
    return Intl.message(
      'Tags',
      name: 'tags',
      desc: '',
      args: [],
    );
  }

  /// `No tournaments for this game`
  String get noTournamentsForGame {
    return Intl.message(
      'No tournaments for this game',
      name: 'noTournamentsForGame',
      desc: '',
      args: [],
    );
  }

  /// `No tournaments found`
  String get noTournamentsFound {
    return Intl.message(
      'No tournaments found',
      name: 'noTournamentsFound',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String errorLoadingTournaments(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'errorLoadingTournaments',
      desc: '',
      args: [error],
    );
  }

  /// `Start: {date}`
  String start(Object date) {
    return Intl.message(
      'Start: $date',
      name: 'start',
      desc: '',
      args: [date],
    );
  }

  /// `End: {date}`
  String end(Object date) {
    return Intl.message(
      'End: $date',
      name: 'end',
      desc: '',
      args: [date],
    );
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user teams`
  String get failedToLoadUserTeams {
    return Intl.message(
      'Failed to load user teams',
      name: 'failedToLoadUserTeams',
      desc: '',
      args: [],
    );
  }

  /// `No teams found for the user`
  String get noTeamsFoundForUser {
    return Intl.message(
      'No teams found for the user',
      name: 'noTeamsFoundForUser',
      desc: '',
      args: [],
    );
  }

  /// `Members: {membersCount} | Tournaments: {tournamentsCount}`
  String membersAndTournaments(Object membersCount, Object tournamentsCount) {
    return Intl.message(
      'Members: $membersCount | Tournaments: $tournamentsCount',
      name: 'membersAndTournaments',
      desc: '',
      args: [membersCount, tournamentsCount],
    );
  }

  /// `Confirm Action`
  String get confirmAction {
    return Intl.message(
      'Confirm Action',
      name: 'confirmAction',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the team {teamName}?`
  String deleteTeamConfirmation(Object teamName) {
    return Intl.message(
      'Are you sure you want to delete the team $teamName?',
      name: 'deleteTeamConfirmation',
      desc: '',
      args: [teamName],
    );
  }

  /// `Are you sure you want to leave the team {teamName}?`
  String leaveTeamConfirmation(Object teamName) {
    return Intl.message(
      'Are you sure you want to leave the team $teamName?',
      name: 'leaveTeamConfirmation',
      desc: '',
      args: [teamName],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Leave`
  String get leave {
    return Intl.message(
      'Leave',
      name: 'leave',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully deleted the team {teamName}`
  String teamDeleted(Object teamName) {
    return Intl.message(
      'You have successfully deleted the team $teamName',
      name: 'teamDeleted',
      desc: '',
      args: [teamName],
    );
  }

  /// `Failed to delete the team: {error}`
  String failedToDeleteTeam(Object error) {
    return Intl.message(
      'Failed to delete the team: $error',
      name: 'failedToDeleteTeam',
      desc: '',
      args: [error],
    );
  }

  /// `You have successfully left the team {teamName}`
  String teamLeft(Object teamName) {
    return Intl.message(
      'You have successfully left the team $teamName',
      name: 'teamLeft',
      desc: '',
      args: [teamName],
    );
  }

  /// `Failed to leave the team`
  String get failedToLeaveTeam {
    return Intl.message(
      'Failed to leave the team',
      name: 'failedToLeaveTeam',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load tournaments`
  String get failedToLoadTournaments {
    return Intl.message(
      'Failed to load tournaments',
      name: 'failedToLoadTournaments',
      desc: '',
      args: [],
    );
  }

  /// `Unknown state`
  String get unknownState {
    return Intl.message(
      'Unknown state',
      name: 'unknownState',
      desc: '',
      args: [],
    );
  }

  /// `Start: {date}`
  String tournamentStartDate(Object date) {
    return Intl.message(
      'Start: $date',
      name: 'tournamentStartDate',
      desc: '',
      args: [date],
    );
  }

  /// `End: {date}`
  String tournamentEndDate(Object date) {
    return Intl.message(
      'End: $date',
      name: 'tournamentEndDate',
      desc: '',
      args: [date],
    );
  }

  /// `Game: {gameName}`
  String gameName(Object gameName) {
    return Intl.message(
      'Game: $gameName',
      name: 'gameName',
      desc: '',
      args: [gameName],
    );
  }

  /// `Number of players per team: {playersCount}`
  String teamPlayersCount(Object playersCount) {
    return Intl.message(
      'Number of players per team: $playersCount',
      name: 'teamPlayersCount',
      desc: '',
      args: [playersCount],
    );
  }

  /// `Error loading current user: {e}`
  String errorLoadingCurrentUser(Object e) {
    return Intl.message(
      'Error loading current user: $e',
      name: 'errorLoadingCurrentUser',
      desc: '',
      args: [e],
    );
  }

  /// `Error checking if upvoted: {e}`
  String errorCheckingIfUpvoted(Object e) {
    return Intl.message(
      'Error checking if upvoted: $e',
      name: 'errorCheckingIfUpvoted',
      desc: '',
      args: [e],
    );
  }

  /// `Error checking if joined: {e}`
  String errorCheckingIfJoined(Object e) {
    return Intl.message(
      'Error checking if joined: $e',
      name: 'errorCheckingIfJoined',
      desc: '',
      args: [e],
    );
  }

  /// `Error loading teams: {e}`
  String errorLoadingTeams(Object e) {
    return Intl.message(
      'Error loading teams: $e',
      name: 'errorLoadingTeams',
      desc: '',
      args: [e],
    );
  }

  /// `No teams available for the current user.`
  String get noTeamsAvailableForUser {
    return Intl.message(
      'No teams available for the current user.',
      name: 'noTeamsAvailableForUser',
      desc: '',
      args: [],
    );
  }

  /// `Select a Team to Join`
  String get selectTeamToJoin {
    return Intl.message(
      'Select a Team to Join',
      name: 'selectTeamToJoin',
      desc: '',
      args: [],
    );
  }

  /// `No teams available.`
  String get noTeamsAvailable {
    return Intl.message(
      'No teams available.',
      name: 'noTeamsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Select a Team to Leave`
  String get selectTeamToLeave {
    return Intl.message(
      'Select a Team to Leave',
      name: 'selectTeamToLeave',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Leave`
  String get confirmLeave {
    return Intl.message(
      'Confirm Leave',
      name: 'confirmLeave',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to leave this tournament?`
  String get confirmLeaveTournament {
    return Intl.message(
      'Are you sure you want to leave this tournament?',
      name: 'confirmLeaveTournament',
      desc: '',
      args: [],
    );
  }

  /// `You must be logged in to upvote`
  String get mustBeLoggedInToUpvote {
    return Intl.message(
      'You must be logged in to upvote',
      name: 'mustBeLoggedInToUpvote',
      desc: '',
      args: [],
    );
  }

  /// `Upvote added`
  String get upvoteAdded {
    return Intl.message(
      'Upvote added',
      name: 'upvoteAdded',
      desc: '',
      args: [],
    );
  }

  /// `Upvote removed`
  String get upvoteRemoved {
    return Intl.message(
      'Upvote removed',
      name: 'upvoteRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Failed to change upvote status: {error}`
  String failedToChangeUpvoteStatus(Object error) {
    return Intl.message(
      'Failed to change upvote status: $error',
      name: 'failedToChangeUpvoteStatus',
      desc: '',
      args: [error],
    );
  }

  /// `You have left the tournament`
  String get leftTournament {
    return Intl.message(
      'You have left the tournament',
      name: 'leftTournament',
      desc: '',
      args: [],
    );
  }

  /// `This team is not registered in the tournament`
  String get teamNotRegistered {
    return Intl.message(
      'This team is not registered in the tournament',
      name: 'teamNotRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Resource not found (404)`
  String get resourceNotFound404 {
    return Intl.message(
      'Resource not found (404)',
      name: 'resourceNotFound404',
      desc: '',
      args: [],
    );
  }

  /// `Error leaving the tournament: {error}`
  String leaveTournamentError(Object error) {
    return Intl.message(
      'Error leaving the tournament: $error',
      name: 'leaveTournamentError',
      desc: '',
      args: [error],
    );
  }

  /// `Unknown error: {error}`
  String unknownError(Object error) {
    return Intl.message(
      'Unknown error: $error',
      name: 'unknownError',
      desc: '',
      args: [error],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Bracket`
  String get bracket {
    return Intl.message(
      'Bracket',
      name: 'bracket',
      desc: '',
      args: [],
    );
  }

  /// `You must be logged in to view your bracket`
  String get mustBeLoggedInToViewBracket {
    return Intl.message(
      'You must be logged in to view your bracket',
      name: 'mustBeLoggedInToViewBracket',
      desc: '',
      args: [],
    );
  }

  /// `Description:`
  String get description {
    return Intl.message(
      'Description:',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Location: {location}`
  String location(Object location) {
    return Intl.message(
      'Location: $location',
      name: 'location',
      desc: '',
      args: [location],
    );
  }

  /// `Game: {gameName}`
  String game(Object gameName) {
    return Intl.message(
      'Game: $gameName',
      name: 'game',
      desc: '',
      args: [gameName],
    );
  }

  /// `Start Date: {date}`
  String startDate(Object date) {
    return Intl.message(
      'Start Date: $date',
      name: 'startDate',
      desc: '',
      args: [date],
    );
  }

  /// `End Date: {date}`
  String endDate(Object date) {
    return Intl.message(
      'End Date: $date',
      name: 'endDate',
      desc: '',
      args: [date],
    );
  }

  /// `Upvotes:`
  String get upvotes {
    return Intl.message(
      'Upvotes:',
      name: 'upvotes',
      desc: '',
      args: [],
    );
  }

  /// `Participants:`
  String get participants {
    return Intl.message(
      'Participants:',
      name: 'participants',
      desc: '',
      args: [],
    );
  }

  /// `View all participants`
  String get viewAllParticipants {
    return Intl.message(
      'View all participants',
      name: 'viewAllParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Generate bracket`
  String get generateBracket {
    return Intl.message(
      'Generate bracket',
      name: 'generateBracket',
      desc: '',
      args: [],
    );
  }

  /// `Join tournament`
  String get joinTournament {
    return Intl.message(
      'Join tournament',
      name: 'joinTournament',
      desc: '',
      args: [],
    );
  }

  /// `Leave tournament`
  String get leaveTournament {
    return Intl.message(
      'Leave tournament',
      name: 'leaveTournament',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully joined the tournament`
  String get joinedTournament {
    return Intl.message(
      'You have successfully joined the tournament',
      name: 'joinedTournament',
      desc: '',
      args: [],
    );
  }

  /// `Team already in this tournament`
  String get teamAlreadyInTournament {
    return Intl.message(
      'Team already in this tournament',
      name: 'teamAlreadyInTournament',
      desc: '',
      args: [],
    );
  }

  /// `You have already joined the tournament`
  String get alreadyJoinedTournament {
    return Intl.message(
      'You have already joined the tournament',
      name: 'alreadyJoinedTournament',
      desc: '',
      args: [],
    );
  }

  /// `Error joining: {error}`
  String joinError(Object error) {
    return Intl.message(
      'Error joining: $error',
      name: 'joinError',
      desc: '',
      args: [error],
    );
  }

  /// `Error joining the tournament`
  String get unknownJoinError {
    return Intl.message(
      'Error joining the tournament',
      name: 'unknownJoinError',
      desc: '',
      args: [],
    );
  }

  /// `Tournament Participants`
  String get tournamentParticipants {
    return Intl.message(
      'Tournament Participants',
      name: 'tournamentParticipants',
      desc: '',
      args: [],
    );
  }

  /// `Edit Tournament`
  String get editTournament {
    return Intl.message(
      'Edit Tournament',
      name: 'editTournament',
      desc: '',
      args: [],
    );
  }

  /// `Tournament updated successfully`
  String get tournamentUpdatedSuccessfully {
    return Intl.message(
      'Tournament updated successfully',
      name: 'tournamentUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update tournament: {error}`
  String failedToUpdateTournament(Object error) {
    return Intl.message(
      'Failed to update tournament: $error',
      name: 'failedToUpdateTournament',
      desc: '',
      args: [error],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name`
  String get pleaseEnterName {
    return Intl.message(
      'Please enter a name',
      name: 'pleaseEnterName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a description`
  String get pleaseEnterDescription {
    return Intl.message(
      'Please enter a description',
      name: 'pleaseEnterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a start date`
  String get pleaseEnterStartDate {
    return Intl.message(
      'Please enter a start date',
      name: 'pleaseEnterStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an end date`
  String get pleaseEnterEndDate {
    return Intl.message(
      'Please enter an end date',
      name: 'pleaseEnterEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a location`
  String get pleaseEnterLocation {
    return Intl.message(
      'Please enter a location',
      name: 'pleaseEnterLocation',
      desc: '',
      args: [],
    );
  }

  /// `Latitude`
  String get latitude {
    return Intl.message(
      'Latitude',
      name: 'latitude',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a latitude`
  String get pleaseEnterLatitude {
    return Intl.message(
      'Please enter a latitude',
      name: 'pleaseEnterLatitude',
      desc: '',
      args: [],
    );
  }

  /// `Longitude`
  String get longitude {
    return Intl.message(
      'Longitude',
      name: 'longitude',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a longitude`
  String get pleaseEnterLongitude {
    return Intl.message(
      'Please enter a longitude',
      name: 'pleaseEnterLongitude',
      desc: '',
      args: [],
    );
  }

  /// `Image URL`
  String get imageUrl {
    return Intl.message(
      'Image URL',
      name: 'imageUrl',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an image URL`
  String get pleaseEnterImageUrl {
    return Intl.message(
      'Please enter an image URL',
      name: 'pleaseEnterImageUrl',
      desc: '',
      args: [],
    );
  }

  /// `Private`
  String get private {
    return Intl.message(
      'Private',
      name: 'private',
      desc: '',
      args: [],
    );
  }

  /// `Game ID`
  String get gameId {
    return Intl.message(
      'Game ID',
      name: 'gameId',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a game ID`
  String get pleaseEnterGameId {
    return Intl.message(
      'Please enter a game ID',
      name: 'pleaseEnterGameId',
      desc: '',
      args: [],
    );
  }

  /// `Number of Players`
  String get numberOfPlayers {
    return Intl.message(
      'Number of Players',
      name: 'numberOfPlayers',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the number of players`
  String get pleaseEnterNumberOfPlayers {
    return Intl.message(
      'Please enter the number of players',
      name: 'pleaseEnterNumberOfPlayers',
      desc: '',
      args: [],
    );
  }

  /// `Validate`
  String get validate {
    return Intl.message(
      'Validate',
      name: 'validate',
      desc: '',
      args: [],
    );
  }

  /// `Add Tournament`
  String get addTournament {
    return Intl.message(
      'Add Tournament',
      name: 'addTournament',
      desc: '',
      args: [],
    );
  }

  /// `Tournament created successfully`
  String get tournamentCreatedSuccessfully {
    return Intl.message(
      'Tournament created successfully',
      name: 'tournamentCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error creating tournament: {error}`
  String failedToCreateTournament(Object error) {
    return Intl.message(
      'Error creating tournament: $error',
      name: 'failedToCreateTournament',
      desc: '',
      args: [error],
    );
  }

  /// `Name is required`
  String get nameIsRequired {
    return Intl.message(
      'Name is required',
      name: 'nameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Description is required`
  String get descriptionIsRequired {
    return Intl.message(
      'Description is required',
      name: 'descriptionIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Start Date is required`
  String get startDateIsRequired {
    return Intl.message(
      'Start Date is required',
      name: 'startDateIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `End Date is required`
  String get endDateIsRequired {
    return Intl.message(
      'End Date is required',
      name: 'endDateIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Game ID is required`
  String get gameIdIsRequired {
    return Intl.message(
      'Game ID is required',
      name: 'gameIdIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Number of Players per Team`
  String get numberOfPlayersPerTeam {
    return Intl.message(
      'Number of Players per Team',
      name: 'numberOfPlayersPerTeam',
      desc: '',
      args: [],
    );
  }

  /// `Number of Players is required`
  String get numberOfPlayersIsRequired {
    return Intl.message(
      'Number of Players is required',
      name: 'numberOfPlayersIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Create Tournament`
  String get createTournament {
    return Intl.message(
      'Create Tournament',
      name: 'createTournament',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Kick`
  String get confirmKick {
    return Intl.message(
      'Confirm Kick',
      name: 'confirmKick',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to kick {username} from the team?`
  String confirmKickMessage(Object username) {
    return Intl.message(
      'Are you sure you want to kick $username from the team?',
      name: 'confirmKickMessage',
      desc: '',
      args: [username],
    );
  }

  /// `Kick`
  String get kick {
    return Intl.message(
      'Kick',
      name: 'kick',
      desc: '',
      args: [],
    );
  }

  /// `Members of {teamName}`
  String membersOfTeam(Object teamName) {
    return Intl.message(
      'Members of $teamName',
      name: 'membersOfTeam',
      desc: '',
      args: [teamName],
    );
  }

  /// `{username} has been successfully kicked from the team`
  String userKickedSuccess(Object username) {
    return Intl.message(
      '$username has been successfully kicked from the team',
      name: 'userKickedSuccess',
      desc: '',
      args: [username],
    );
  }

  /// `Error kicking user: {error}`
  String errorKickingUser(Object error) {
    return Intl.message(
      'Error kicking user: $error',
      name: 'errorKickingUser',
      desc: '',
      args: [error],
    );
  }

  /// `Add Team`
  String get addTeam {
    return Intl.message(
      'Add Team',
      name: 'addTeam',
      desc: '',
      args: [],
    );
  }

  /// `Team created successfully`
  String get teamCreatedSuccessfully {
    return Intl.message(
      'Team created successfully',
      name: 'teamCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error creating team: {error}`
  String failedToCreateTeam(Object error) {
    return Intl.message(
      'Error creating team: $error',
      name: 'failedToCreateTeam',
      desc: '',
      args: [error],
    );
  }

  /// `Create Team`
  String get createTeam {
    return Intl.message(
      'Create Team',
      name: 'createTeam',
      desc: '',
      args: [],
    );
  }

  /// `No rating fetched`
  String get noRatingFetched {
    return Intl.message(
      'No rating fetched',
      name: 'noRatingFetched',
      desc: '',
      args: [],
    );
  }

  /// `Rating fetched successfully`
  String get ratingFetchedSuccessfully {
    return Intl.message(
      'Rating fetched successfully',
      name: 'ratingFetchedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching rating`
  String get errorFetchingRating {
    return Intl.message(
      'Error fetching rating',
      name: 'errorFetchingRating',
      desc: '',
      args: [],
    );
  }

  /// `Rating cannot be zero`
  String get ratingCannotBeZero {
    return Intl.message(
      'Rating cannot be zero',
      name: 'ratingCannotBeZero',
      desc: '',
      args: [],
    );
  }

  /// `Rating saved successfully`
  String get ratingSavedSuccessfully {
    return Intl.message(
      'Rating saved successfully',
      name: 'ratingSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error saving rating`
  String get errorSavingRating {
    return Intl.message(
      'Error saving rating',
      name: 'errorSavingRating',
      desc: '',
      args: [],
    );
  }

  /// `Your rating:`
  String get yourRating {
    return Intl.message(
      'Your rating:',
      name: 'yourRating',
      desc: '',
      args: [],
    );
  }

  /// `Custom Bracket`
  String get customBracket {
    return Intl.message(
      'Custom Bracket',
      name: 'customBracket',
      desc: '',
      args: [],
    );
  }

  /// `Custom Poules`
  String get customPoules {
    return Intl.message(
      'Custom Poules',
      name: 'customPoules',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load users`
  String get failedToLoadUsers {
    return Intl.message(
      'Failed to load users',
      name: 'failedToLoadUsers',
      desc: '',
      args: [],
    );
  }

  /// `No users found`
  String get noUsersFound {
    return Intl.message(
      'No users found',
      name: 'noUsersFound',
      desc: '',
      args: [],
    );
  }

  /// `View games`
  String get viewGames {
    return Intl.message(
      'View games',
      name: 'viewGames',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get friends {
    return Intl.message(
      'Friends',
      name: 'friends',
      desc: '',
      args: [],
    );
  }

  /// `Notification deleted`
  String get notificationDeleted {
    return Intl.message(
      'Notification deleted',
      name: 'notificationDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Add Friend`
  String get addFriend {
    return Intl.message(
      'Add Friend',
      name: 'addFriend',
      desc: '',
      args: [],
    );
  }

  /// `Search User`
  String get searchUser {
    return Intl.message(
      'Search User',
      name: 'searchUser',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Friend added successfully`
  String get friendAddedSuccessfully {
    return Intl.message(
      'Friend added successfully',
      name: 'friendAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Friend already added`
  String get friendAlreadyAdded {
    return Intl.message(
      'Friend already added',
      name: 'friendAlreadyAdded',
      desc: '',
      args: [],
    );
  }

  /// `Error adding friend`
  String get errorAddingFriend {
    return Intl.message(
      'Error adding friend',
      name: 'errorAddingFriend',
      desc: '',
      args: [],
    );
  }

  /// `Friend details`
  String get friendDetails {
    return Intl.message(
      'Friend details',
      name: 'friendDetails',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get friendsTab {
    return Intl.message(
      'Friends',
      name: 'friendsTab',
      desc: '',
      args: [],
    );
  }

  /// `Sort A-Z`
  String get sortAToZ {
    return Intl.message(
      'Sort A-Z',
      name: 'sortAToZ',
      desc: '',
      args: [],
    );
  }

  /// `Sort Z-A`
  String get sortZToA {
    return Intl.message(
      'Sort Z-A',
      name: 'sortZToA',
      desc: '',
      args: [],
    );
  }

  /// `No friends found`
  String get noFriendsFound {
    return Intl.message(
      'No friends found',
      name: 'noFriendsFound',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete {friendName} from your friends?`
  String confirmDeleteFriend(Object friendName) {
    return Intl.message(
      'Are you sure you want to delete $friendName from your friends?',
      name: 'confirmDeleteFriend',
      desc: '',
      args: [friendName],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load friends`
  String get failedToLoadFriends {
    return Intl.message(
      'Failed to load friends',
      name: 'failedToLoadFriends',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update favorite status`
  String get failedToUpdateFavoriteStatus {
    return Intl.message(
      'Failed to update favorite status',
      name: 'failedToUpdateFavoriteStatus',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete friend`
  String get failedToDeleteFriend {
    return Intl.message(
      'Failed to delete friend',
      name: 'failedToDeleteFriend',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Bracket updated`
  String get bracketUpdated {
    return Intl.message(
      'Bracket updated',
      name: 'bracketUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load bracket`
  String get failedToLoadBracket {
    return Intl.message(
      'Failed to load bracket',
      name: 'failedToLoadBracket',
      desc: '',
      args: [],
    );
  }

  /// `Waiting`
  String get waiting {
    return Intl.message(
      'Waiting',
      name: 'waiting',
      desc: '',
      args: [],
    );
  }

  /// `Tournament Pools`
  String get poulesTitle {
    return Intl.message(
      'Tournament Pools',
      name: 'poulesTitle',
      desc: '',
      args: [],
    );
  }

  /// `View Brackets`
  String get viewBrackets {
    return Intl.message(
      'View Brackets',
      name: 'viewBrackets',
      desc: '',
      args: [],
    );
  }

  /// `Team`
  String get team {
    return Intl.message(
      'Team',
      name: 'team',
      desc: '',
      args: [],
    );
  }

  /// `Score`
  String get score {
    return Intl.message(
      'Score',
      name: 'score',
      desc: '',
      args: [],
    );
  }

  /// `Match Details`
  String get matchDetails {
    return Intl.message(
      'Match Details',
      name: 'matchDetails',
      desc: '',
      args: [],
    );
  }

  /// `Update Score`
  String get updateScore {
    return Intl.message(
      'Update Score',
      name: 'updateScore',
      desc: '',
      args: [],
    );
  }

  /// `Close Match`
  String get closeMatch {
    return Intl.message(
      'Close Match',
      name: 'closeMatch',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Close`
  String get cancelClose {
    return Intl.message(
      'Cancel Close',
      name: 'cancelClose',
      desc: '',
      args: [],
    );
  }

  /// `Update Match`
  String get updateMatch {
    return Intl.message(
      'Update Match',
      name: 'updateMatch',
      desc: '',
      args: [],
    );
  }

  /// `Propose to close`
  String get proposeToClose {
    return Intl.message(
      'Propose to close',
      name: 'proposeToClose',
      desc: '',
      args: [],
    );
  }

  /// `No winner yet`
  String get noWinnerYet {
    return Intl.message(
      'No winner yet',
      name: 'noWinnerYet',
      desc: '',
      args: [],
    );
  }

  /// `Cancel close`
  String get cancelCloseMatch {
    return Intl.message(
      'Cancel close',
      name: 'cancelCloseMatch',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Winner`
  String get winner {
    return Intl.message(
      'Winner',
      name: 'winner',
      desc: '',
      args: [],
    );
  }

  /// `Team 1 Score`
  String get team1Score {
    return Intl.message(
      'Team 1 Score',
      name: 'team1Score',
      desc: '',
      args: [],
    );
  }

  /// `Team 2 Score`
  String get team2Score {
    return Intl.message(
      'Team 2 Score',
      name: 'team2Score',
      desc: '',
      args: [],
    );
  }

  /// `Pool Brackets`
  String get pouleBrackets {
    return Intl.message(
      'Pool Brackets',
      name: 'pouleBrackets',
      desc: '',
      args: [],
    );
  }

  /// `Enter result for`
  String get enterResult {
    return Intl.message(
      'Enter result for',
      name: 'enterResult',
      desc: '',
      args: [],
    );
  }

  /// `VS`
  String get vs {
    return Intl.message(
      'VS',
      name: 'vs',
      desc: '',
      args: [],
    );
  }

  /// `Add Game`
  String get addGame {
    return Intl.message(
      'Add Game',
      name: 'addGame',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the game name`
  String get pleaseEnterGameName {
    return Intl.message(
      'Please enter the game name',
      name: 'pleaseEnterGameName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the game description`
  String get pleaseEnterGameDescription {
    return Intl.message(
      'Please enter the game description',
      name: 'pleaseEnterGameDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the tags`
  String get pleaseEnterTags {
    return Intl.message(
      'Please enter the tags',
      name: 'pleaseEnterTags',
      desc: '',
      args: [],
    );
  }

  /// `Game added`
  String get gameAdded {
    return Intl.message(
      'Game added',
      name: 'gameAdded',
      desc: '',
      args: [],
    );
  }

  /// `Error adding game`
  String get errorAddingGame {
    return Intl.message(
      'Error adding game',
      name: 'errorAddingGame',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Start Date & Time`
  String get startDateTime {
    return Intl.message(
      'Start Date & Time',
      name: 'startDateTime',
      desc: '',
      args: [],
    );
  }

  /// `End Date & Time`
  String get endDateTime {
    return Intl.message(
      'End Date & Time',
      name: 'endDateTime',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the tournament name`
  String get pleaseEnterTournamentName {
    return Intl.message(
      'Please enter the tournament name',
      name: 'pleaseEnterTournamentName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the tournament description`
  String get pleaseEnterTournamentDescription {
    return Intl.message(
      'Please enter the tournament description',
      name: 'pleaseEnterTournamentDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please enter if the tournament is private`
  String get pleaseEnterIfTournamentIsPrivate {
    return Intl.message(
      'Please enter if the tournament is private',
      name: 'pleaseEnterIfTournamentIsPrivate',
      desc: '',
      args: [],
    );
  }

  /// `Tournament added`
  String get tournamentAdded {
    return Intl.message(
      'Tournament added',
      name: 'tournamentAdded',
      desc: '',
      args: [],
    );
  }

  /// `Error adding tournament`
  String get errorAddingTournament {
    return Intl.message(
      'Error adding tournament',
      name: 'errorAddingTournament',
      desc: '',
      args: [],
    );
  }

  /// `Select Start Date`
  String get selectStartDate {
    return Intl.message(
      'Select Start Date',
      name: 'selectStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Select End Date`
  String get selectEndDate {
    return Intl.message(
      'Select End Date',
      name: 'selectEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all required fields and select dates and times`
  String get pleaseFillRequiredFields {
    return Intl.message(
      'Please fill in all required fields and select dates and times',
      name: 'pleaseFillRequiredFields',
      desc: '',
      args: [],
    );
  }

  /// `Description:`
  String get descriptionGame {
    return Intl.message(
      'Description:',
      name: 'descriptionGame',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTab {
    return Intl.message(
      'Profile',
      name: 'profileTab',
      desc: '',
      args: [],
    );
  }

  /// `Liked Games`
  String get likedGamesTab {
    return Intl.message(
      'Liked Games',
      name: 'likedGamesTab',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated`
  String get profileUpdated {
    return Intl.message(
      'Profile updated',
      name: 'profileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Error saving profile`
  String get errorSavingProfile {
    return Intl.message(
      'Error saving profile',
      name: 'errorSavingProfile',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get deleteAccountConfirmation {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'deleteAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting account`
  String get errorDeletingAccount {
    return Intl.message(
      'Error deleting account',
      name: 'errorDeletingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Photo Library`
  String get photoLibrary {
    return Intl.message(
      'Photo Library',
      name: 'photoLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Error picking image`
  String get errorPickingImage {
    return Intl.message(
      'Error picking image',
      name: 'errorPickingImage',
      desc: '',
      args: [],
    );
  }

  /// `Error uploading profile image`
  String get errorUploadingProfileImage {
    return Intl.message(
      'Error uploading profile image',
      name: 'errorUploadingProfileImage',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching liked games`
  String get errorFetchingLikedGames {
    return Intl.message(
      'Error fetching liked games',
      name: 'errorFetchingLikedGames',
      desc: '',
      args: [],
    );
  }

  /// `No liked games found`
  String get noLikedGames {
    return Intl.message(
      'No liked games found',
      name: 'noLikedGames',
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
