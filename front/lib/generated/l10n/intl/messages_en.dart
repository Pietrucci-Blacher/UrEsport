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

  static String m0(count) => "Filters (${count})";

  static String m1(count) => "+${count} more";

  static String m2(username) => "Welcome to your profile, ${username}!";

  static String m3(email) => "A verification code has been sent to ${email}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "alphabeticalAZ":
            MessageLookupByLibrary.simpleMessage("Alphabetical (A-Z)"),
        "alphabeticalZA":
            MessageLookupByLibrary.simpleMessage("Alphabetical (Z-A)"),
        "anErrorOccurred":
            MessageLookupByLibrary.simpleMessage("An error occurred!"),
        "appTitle": MessageLookupByLibrary.simpleMessage("UrEsport"),
        "applyFilters": MessageLookupByLibrary.simpleMessage("Apply Filters"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelEditing": MessageLookupByLibrary.simpleMessage("Cancel Editing"),
        "closeButton": MessageLookupByLibrary.simpleMessage("Close"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "dangerZone": MessageLookupByLibrary.simpleMessage("Danger Zone"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
        "deleteGameButton": MessageLookupByLibrary.simpleMessage("Delete Game"),
        "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "filterAndSort":
            MessageLookupByLibrary.simpleMessage("Filter and Sort"),
        "filterByTags": MessageLookupByLibrary.simpleMessage("FILTER BY TAGS"),
        "filters": m0,
        "firstName": MessageLookupByLibrary.simpleMessage("First Name"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "gameButton": MessageLookupByLibrary.simpleMessage("All Games"),
        "gameScreenTitle": MessageLookupByLibrary.simpleMessage("Games"),
        "gameScreenWelcome":
            MessageLookupByLibrary.simpleMessage("Welcome to the Game Screen!"),
        "homeScreenTitle": MessageLookupByLibrary.simpleMessage("Home"),
        "homeScreenWelcome":
            MessageLookupByLibrary.simpleMessage("Welcome to the Home Screen!"),
        "inviteButton": MessageLookupByLibrary.simpleMessage("Invite"),
        "inviteError": MessageLookupByLibrary.simpleMessage(
            "An error occurred while sending the invitation"),
        "inviteSuccess": MessageLookupByLibrary.simpleMessage(
            "You have been invited successfully"),
        "joinButton": MessageLookupByLibrary.simpleMessage("Join"),
        "lastName": MessageLookupByLibrary.simpleMessage("Last Name"),
        "logIn": MessageLookupByLibrary.simpleMessage("Log In"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "modifyGameButton": MessageLookupByLibrary.simpleMessage("Modify Game"),
        "moreTagsCount": m1,
        "noGamesAvailable":
            MessageLookupByLibrary.simpleMessage("No games available."),
        "notificationScreenTitle":
            MessageLookupByLibrary.simpleMessage("Notifications"),
        "notificationScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Welcome to the Notification screen!"),
        "orLoginWith": MessageLookupByLibrary.simpleMessage("Or login with"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordResetEmailSent":
            MessageLookupByLibrary.simpleMessage("Password reset email sent"),
        "passwordResetSuccessful":
            MessageLookupByLibrary.simpleMessage("Password reset successful"),
        "popularGamesTitle":
            MessageLookupByLibrary.simpleMessage("Popular Games"),
        "profileScreenTitle": MessageLookupByLibrary.simpleMessage("Profile"),
        "profileScreenWelcome": m2,
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "resendCode": MessageLookupByLibrary.simpleMessage("Resend code"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "searchTags": MessageLookupByLibrary.simpleMessage("Search tags"),
        "sendResetEmail":
            MessageLookupByLibrary.simpleMessage("Send Reset Email"),
        "sort": MessageLookupByLibrary.simpleMessage("SORT"),
        "tournamentScreenTitle":
            MessageLookupByLibrary.simpleMessage("Tournaments"),
        "tournamentScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Welcome to the Tournament Screen!"),
        "trendingTournamentsTitle":
            MessageLookupByLibrary.simpleMessage("Trending Tournaments"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "verificationCodeSent": m3,
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "viewAll": MessageLookupByLibrary.simpleMessage("View All"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome to UrEsport"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("You are not logged in")
      };
}
