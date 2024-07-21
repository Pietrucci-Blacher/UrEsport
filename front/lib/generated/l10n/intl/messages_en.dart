// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(date) => "End: ${date}";

  static String m1(error) => "Error following the game: ${error}";

  static String m2(error) => "Error: ${error}";

  static String m3(error) => "Error unfollowing the game: ${error}";

  static String m4(count) => "Filters (${count})";

  static String m5(count) => "+${count} more";

  static String m6(username) => "Welcome to your profile, ${username}!";

  static String m7(date) => "Start: ${date}";

  static String m8(email) => "A verification code has been sent to ${email}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "actions": MessageLookupByLibrary.simpleMessage("Actions"),
        "activeTournaments":
            MessageLookupByLibrary.simpleMessage("Active Tournaments"),
        "activeUsers": MessageLookupByLibrary.simpleMessage("Active Users"),
        "addedToGameList":
            MessageLookupByLibrary.simpleMessage("Game added to your list"),
        "alphabeticalAZ":
            MessageLookupByLibrary.simpleMessage("Alphabetical (A-Z)"),
        "alphabeticalZA":
            MessageLookupByLibrary.simpleMessage("Alphabetical (Z-A)"),
        "alreadyJoinedTournament": MessageLookupByLibrary.simpleMessage(
            "You have already joined this tournament"),
        "anErrorOccurred":
            MessageLookupByLibrary.simpleMessage("An error occurred!"),
        "appTitle": MessageLookupByLibrary.simpleMessage("UrEsport"),
        "applyFilters": MessageLookupByLibrary.simpleMessage("Apply Filters"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelEditing": MessageLookupByLibrary.simpleMessage("Cancel Editing"),
        "closeButton": MessageLookupByLibrary.simpleMessage("Close"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmDeleteGame": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this game?"),
        "dangerZone": MessageLookupByLibrary.simpleMessage("Danger Zone"),
        "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
        "deleteGame": MessageLookupByLibrary.simpleMessage("Delete Game"),
        "deleteGameButton": MessageLookupByLibrary.simpleMessage("Delete Game"),
        "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "end": m0,
        "errorFetchingRating":
            MessageLookupByLibrary.simpleMessage("Error fetching rating"),
        "errorFollowingGame": m1,
        "errorLoading":
            MessageLookupByLibrary.simpleMessage("Error loading data"),
        "errorLoadingTournaments": m2,
        "errorSavingRating":
            MessageLookupByLibrary.simpleMessage("Error saving rating"),
        "errorUnfollowingGame": m3,
        "filterAndSort":
            MessageLookupByLibrary.simpleMessage("Filter and Sort"),
        "filterByTags": MessageLookupByLibrary.simpleMessage("FILTER BY TAGS"),
        "filters": m4,
        "firstName": MessageLookupByLibrary.simpleMessage("First Name"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "gameButton": MessageLookupByLibrary.simpleMessage("All Games"),
        "gameDescription":
            MessageLookupByLibrary.simpleMessage("Game Description"),
        "gameDetailPageTitle":
            MessageLookupByLibrary.simpleMessage("Game Details"),
        "gameScreenTitle": MessageLookupByLibrary.simpleMessage("Games"),
        "gameScreenWelcome":
            MessageLookupByLibrary.simpleMessage("Welcome to the Game Screen!"),
        "games": MessageLookupByLibrary.simpleMessage("Games"),
        "generateBracket":
            MessageLookupByLibrary.simpleMessage("Generate Bracket"),
        "homeScreenTitle": MessageLookupByLibrary.simpleMessage("Home"),
        "homeScreenWelcome":
            MessageLookupByLibrary.simpleMessage("Welcome to the Home Screen!"),
        "inviteButton": MessageLookupByLibrary.simpleMessage("Invite"),
        "inviteError": MessageLookupByLibrary.simpleMessage(
            "An error occurred while sending the invitation"),
        "inviteSuccess": MessageLookupByLibrary.simpleMessage(
            "You have been invited successfully"),
        "joinButton": MessageLookupByLibrary.simpleMessage("Join"),
        "joinTournament":
            MessageLookupByLibrary.simpleMessage("Join Tournament"),
        "joinedTournaments": MessageLookupByLibrary.simpleMessage(
            "You have successfully joined the tournament"),
        "lastName": MessageLookupByLibrary.simpleMessage("Last Name"),
        "latestMessage": MessageLookupByLibrary.simpleMessage("Latest Message"),
        "leaveTournament":
            MessageLookupByLibrary.simpleMessage("Leave Tournament"),
        "leftTournament": MessageLookupByLibrary.simpleMessage(
            "You have left the tournament"),
        "listAllTournaments":
            MessageLookupByLibrary.simpleMessage("List tournaments"),
        "listMyTeamsJoined": MessageLookupByLibrary.simpleMessage("My Teams"),
        "listMyTournaments":
            MessageLookupByLibrary.simpleMessage("My tournaments"),
        "logIn": MessageLookupByLibrary.simpleMessage("Log In"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "logs": MessageLookupByLibrary.simpleMessage("Logs"),
        "modifyGameButton": MessageLookupByLibrary.simpleMessage("Modify Game"),
        "moreTagsCount": m5,
        "mustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "You must be logged in to view your tournaments"),
        "needConnected": MessageLookupByLibrary.simpleMessage(
            "You must be logged in to access this page"),
        "noGamesAvailable":
            MessageLookupByLibrary.simpleMessage("No games available."),
        "noJoinedTournaments":
            MessageLookupByLibrary.simpleMessage("No joined tournaments"),
        "noLikeToDelete":
            MessageLookupByLibrary.simpleMessage("No like to delete"),
        "noRatingFetched":
            MessageLookupByLibrary.simpleMessage("No rating fetched"),
        "noTournamentsForGame": MessageLookupByLibrary.simpleMessage(
            "No tournaments for this game"),
        "noTournamentsFound":
            MessageLookupByLibrary.simpleMessage("No tournaments found"),
        "notificationScreenTitle":
            MessageLookupByLibrary.simpleMessage("Notifications"),
        "notificationScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Welcome to the Notification screen!"),
        "orLoginWith": MessageLookupByLibrary.simpleMessage("Or login with"),
        "participants": MessageLookupByLibrary.simpleMessage("Participants"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordResetEmailSent":
            MessageLookupByLibrary.simpleMessage("Password reset email sent"),
        "passwordResetSuccessful":
            MessageLookupByLibrary.simpleMessage("Password reset successful"),
        "popularGamesTitle":
            MessageLookupByLibrary.simpleMessage("Popular Games"),
        "profileScreenTitle": MessageLookupByLibrary.simpleMessage("Profile"),
        "profileScreenWelcome": m6,
        "ratingCannotBeZero":
            MessageLookupByLibrary.simpleMessage("Rating cannot be zero"),
        "ratingFetchedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Rating fetched successfully"),
        "ratingSavedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Rating saved successfully"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "removedFromGameList":
            MessageLookupByLibrary.simpleMessage("Game removed from your list"),
        "removedFromLikedGames": MessageLookupByLibrary.simpleMessage(
            "Game removed from your liked games"),
        "resendCode": MessageLookupByLibrary.simpleMessage("Resend code"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "searchTags": MessageLookupByLibrary.simpleMessage("Search tags"),
        "sendResetEmail":
            MessageLookupByLibrary.simpleMessage("Send Reset Email"),
        "sort": MessageLookupByLibrary.simpleMessage("SORT"),
        "start": m7,
        "tags": MessageLookupByLibrary.simpleMessage("Tags"),
        "teamCreatedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Team created successfully"),
        "totalGames": MessageLookupByLibrary.simpleMessage("Total Games"),
        "tournamentScreenTitle":
            MessageLookupByLibrary.simpleMessage("Tournaments"),
        "tournamentScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Welcome to the Tournament Screen!"),
        "tournaments": MessageLookupByLibrary.simpleMessage("Tournaments"),
        "trendingTournamentsTitle":
            MessageLookupByLibrary.simpleMessage("Trending Tournaments"),
        "unknownPage": MessageLookupByLibrary.simpleMessage("Unknown Page"),
        "upvoteAdded": MessageLookupByLibrary.simpleMessage("Upvote added"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "users": MessageLookupByLibrary.simpleMessage("Users"),
        "verificationCodeSent": m8,
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "viewAll": MessageLookupByLibrary.simpleMessage("View All"),
        "viewAllParticipants":
            MessageLookupByLibrary.simpleMessage("View all participants"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome to UrEsport"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("You are not logged in"),
        "youMustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "You must be logged in to follow this game"),
        "yourRating": MessageLookupByLibrary.simpleMessage("Your Rating:")
      };
}
