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

  static String m0(friendName) =>
      "Are you sure you want to delete ${friendName} from your friends?";

  static String m1(username) =>
      "Are you sure you want to kick ${username} from the team?";

  static String m2(teamName) =>
      "Are you sure you want to delete the team ${teamName}?";

  static String m3(date) => "End: ${date}";

  static String m4(date) => "End Date: ${date}";

  static String m5(e) => "Error checking if joined: ${e}";

  static String m6(e) => "Error checking if upvoted: ${e}";

  static String m7(error) => "Error following the game: ${error}";

  static String m8(error) => "Error kicking user: ${error}";

  static String m9(e) => "Error loading current user: ${e}";

  static String m10(e) => "Error loading teams: ${e}";

  static String m11(error) => "Error: ${error}";

  static String m12(error) => "Error unfollowing the game: ${error}";

  static String m13(error) => "Failed to change upvote status: ${error}";

  static String m14(error) => "Error creating team: ${error}";

  static String m15(error) => "Error creating tournament: ${error}";

  static String m16(error) => "Failed to delete the team: ${error}";

  static String m17(error) => "Failed to update tournament: ${error}";

  static String m18(count) => "Filters (${count})";

  static String m19(gameName) => "Game: ${gameName}";

  static String m20(gameName) => "Game: ${gameName}";

  static String m21(error) => "Error joining: ${error}";

  static String m22(teamName) =>
      "Are you sure you want to leave the team ${teamName}?";

  static String m23(error) => "Error leaving the tournament: ${error}";

  static String m24(location) => "Location: ${location}";

  static String m25(membersCount, tournamentsCount) =>
      "Members: ${membersCount} | Tournaments: ${tournamentsCount}";

  static String m26(teamName) => "Members of ${teamName}";

  static String m27(count) => "+${count} more";

  static String m28(username) => "Welcome to your profile, ${username}!";

  static String m29(date) => "Start: ${date}";

  static String m30(date) => "Start Date: ${date}";

  static String m31(teamName) =>
      "You have successfully deleted the team ${teamName}";

  static String m32(teamName) =>
      "You have successfully left the team ${teamName}";

  static String m33(playersCount) =>
      "Number of players per team: ${playersCount}";

  static String m34(date) => "End: ${date}";

  static String m35(date) => "Start: ${date}";

  static String m36(error) => "Unknown error: ${error}";

  static String m37(username) =>
      "${username} has been successfully kicked from the team";

  static String m38(email) => "A verification code has been sent to ${email}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "actions": MessageLookupByLibrary.simpleMessage("Actions"),
        "activeTournaments":
            MessageLookupByLibrary.simpleMessage("Active Tournaments"),
        "activeUsers": MessageLookupByLibrary.simpleMessage("Active Users"),
        "addFriend": MessageLookupByLibrary.simpleMessage("Add Friend"),
        "addGame": MessageLookupByLibrary.simpleMessage("Add Game"),
        "addTeam": MessageLookupByLibrary.simpleMessage("Add Team"),
        "addTournament": MessageLookupByLibrary.simpleMessage("Add Tournament"),
        "addedToGameList":
            MessageLookupByLibrary.simpleMessage("Game added to your list"),
        "alphabeticalAZ":
            MessageLookupByLibrary.simpleMessage("Alphabetical (A-Z)"),
        "alphabeticalZA":
            MessageLookupByLibrary.simpleMessage("Alphabetical (Z-A)"),
        "alreadyJoinedTournament": MessageLookupByLibrary.simpleMessage(
            "You have already joined the tournament"),
        "anErrorOccurred":
            MessageLookupByLibrary.simpleMessage("An error occurred!"),
        "appTitle": MessageLookupByLibrary.simpleMessage("UrEsport"),
        "applyFilters": MessageLookupByLibrary.simpleMessage("Apply Filters"),
        "bracket": MessageLookupByLibrary.simpleMessage("Bracket"),
        "bracketUpdated":
            MessageLookupByLibrary.simpleMessage("Bracket updated"),
        "camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelClose": MessageLookupByLibrary.simpleMessage("Cancel Close"),
        "cancelCloseMatch":
            MessageLookupByLibrary.simpleMessage("Cancel close"),
        "cancelEditing": MessageLookupByLibrary.simpleMessage("Cancel Editing"),
        "closeButton": MessageLookupByLibrary.simpleMessage("Close"),
        "closeMatch": MessageLookupByLibrary.simpleMessage("Close Match"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmAction": MessageLookupByLibrary.simpleMessage("Confirm Action"),
        "confirmDeleteFriend": m0,
        "confirmDeleteGame": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this game?"),
        "confirmKick": MessageLookupByLibrary.simpleMessage("Confirm Kick"),
        "confirmKickMessage": m1,
        "confirmLeave": MessageLookupByLibrary.simpleMessage("Confirm Leave"),
        "confirmLeaveTournament": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to leave this tournament?"),
        "createTeam": MessageLookupByLibrary.simpleMessage("Create Team"),
        "createTournament":
            MessageLookupByLibrary.simpleMessage("Create Tournament"),
        "customBracket": MessageLookupByLibrary.simpleMessage("Custom Bracket"),
        "customPoules": MessageLookupByLibrary.simpleMessage("Custom Poules"),
        "dangerZone": MessageLookupByLibrary.simpleMessage("Danger Zone"),
        "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
        "deleteAccountConfirmation": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete your account?"),
        "deleteGame": MessageLookupByLibrary.simpleMessage("Delete Game"),
        "deleteGameButton": MessageLookupByLibrary.simpleMessage("Delete Game"),
        "deleteTeamConfirmation": m2,
        "description": MessageLookupByLibrary.simpleMessage("Description:"),
        "descriptionGame": MessageLookupByLibrary.simpleMessage("Description:"),
        "descriptionIsRequired":
            MessageLookupByLibrary.simpleMessage("Description is required"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
        "editTournament":
            MessageLookupByLibrary.simpleMessage("Edit Tournament"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "end": m3,
        "endDate": m4,
        "endDateIsRequired":
            MessageLookupByLibrary.simpleMessage("End Date is required"),
        "endDateTime": MessageLookupByLibrary.simpleMessage("End Date & Time"),
        "enterResult": MessageLookupByLibrary.simpleMessage("Enter result for"),
        "errorAddingFriend":
            MessageLookupByLibrary.simpleMessage("Error adding friend"),
        "errorAddingGame":
            MessageLookupByLibrary.simpleMessage("Error adding game"),
        "errorAddingTournament":
            MessageLookupByLibrary.simpleMessage("Error adding tournament"),
        "errorCheckingIfJoined": m5,
        "errorCheckingIfUpvoted": m6,
        "errorDeletingAccount":
            MessageLookupByLibrary.simpleMessage("Error deleting account"),
        "errorFetchingLikedGames":
            MessageLookupByLibrary.simpleMessage("Error fetching liked games"),
        "errorFetchingRating":
            MessageLookupByLibrary.simpleMessage("Error fetching rating"),
        "errorFollowingGame": m7,
        "errorKickingUser": m8,
        "errorLoading":
            MessageLookupByLibrary.simpleMessage("Error loading data"),
        "errorLoadingCurrentUser": m9,
        "errorLoadingTeams": m10,
        "errorLoadingTournaments": m11,
        "errorPickingImage":
            MessageLookupByLibrary.simpleMessage("Error picking image"),
        "errorSavingProfile":
            MessageLookupByLibrary.simpleMessage("Error saving profile"),
        "errorSavingRating":
            MessageLookupByLibrary.simpleMessage("Error saving rating"),
        "errorUnfollowingGame": m12,
        "errorUploadingProfileImage": MessageLookupByLibrary.simpleMessage(
            "Error uploading profile image"),
        "failedToChangeUpvoteStatus": m13,
        "failedToCreateTeam": m14,
        "failedToCreateTournament": m15,
        "failedToDeleteFriend":
            MessageLookupByLibrary.simpleMessage("Failed to delete friend"),
        "failedToDeleteTeam": m16,
        "failedToLeaveTeam":
            MessageLookupByLibrary.simpleMessage("Failed to leave the team"),
        "failedToLoadBracket":
            MessageLookupByLibrary.simpleMessage("Failed to load bracket"),
        "failedToLoadFriends":
            MessageLookupByLibrary.simpleMessage("Failed to load friends"),
        "failedToLoadTournaments":
            MessageLookupByLibrary.simpleMessage("Failed to load tournaments"),
        "failedToLoadUserTeams":
            MessageLookupByLibrary.simpleMessage("Failed to load user teams"),
        "failedToLoadUsers":
            MessageLookupByLibrary.simpleMessage("Failed to load users"),
        "failedToUpdateFavoriteStatus": MessageLookupByLibrary.simpleMessage(
            "Failed to update favorite status"),
        "failedToUpdateTournament": m17,
        "favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
        "filterAndSort":
            MessageLookupByLibrary.simpleMessage("Filter and Sort"),
        "filterByTags": MessageLookupByLibrary.simpleMessage("FILTER BY TAGS"),
        "filters": m18,
        "firstName": MessageLookupByLibrary.simpleMessage("First Name"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "friendAddedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Friend added successfully"),
        "friendAlreadyAdded":
            MessageLookupByLibrary.simpleMessage("Friend already added"),
        "friendDetails": MessageLookupByLibrary.simpleMessage("Friend details"),
        "friends": MessageLookupByLibrary.simpleMessage("Friends"),
        "friendsTab": MessageLookupByLibrary.simpleMessage("Friends"),
        "game": m19,
        "gameAdded": MessageLookupByLibrary.simpleMessage("Game added"),
        "gameButton": MessageLookupByLibrary.simpleMessage("All Games"),
        "gameDescription":
            MessageLookupByLibrary.simpleMessage("Game Description"),
        "gameDetailPageTitle":
            MessageLookupByLibrary.simpleMessage("Game Details"),
        "gameId": MessageLookupByLibrary.simpleMessage("Game ID"),
        "gameIdIsRequired":
            MessageLookupByLibrary.simpleMessage("Game ID is required"),
        "gameName": m20,
        "gameScreenTitle": MessageLookupByLibrary.simpleMessage("Games"),
        "gameScreenWelcome":
            MessageLookupByLibrary.simpleMessage("Welcome to the Game Screen!"),
        "games": MessageLookupByLibrary.simpleMessage("Games"),
        "generateBracket":
            MessageLookupByLibrary.simpleMessage("Generate bracket"),
        "homeScreenTitle": MessageLookupByLibrary.simpleMessage("Home"),
        "homeScreenWelcome":
            MessageLookupByLibrary.simpleMessage("Welcome to the Home Screen!"),
        "imageUrl": MessageLookupByLibrary.simpleMessage("Image URL"),
        "inviteButton": MessageLookupByLibrary.simpleMessage("Invite"),
        "inviteError": MessageLookupByLibrary.simpleMessage(
            "An error occurred while sending the invitation"),
        "inviteSuccess": MessageLookupByLibrary.simpleMessage(
            "You have been invited successfully"),
        "joinButton": MessageLookupByLibrary.simpleMessage("Join"),
        "joinError": m21,
        "joinTournament":
            MessageLookupByLibrary.simpleMessage("Join tournament"),
        "joinedTournament": MessageLookupByLibrary.simpleMessage(
            "You have successfully joined the tournament"),
        "kick": MessageLookupByLibrary.simpleMessage("Kick"),
        "lastName": MessageLookupByLibrary.simpleMessage("Last Name"),
        "latestMessage": MessageLookupByLibrary.simpleMessage("Latest Message"),
        "latitude": MessageLookupByLibrary.simpleMessage("Latitude"),
        "leave": MessageLookupByLibrary.simpleMessage("Leave"),
        "leaveTeamConfirmation": m22,
        "leaveTournament":
            MessageLookupByLibrary.simpleMessage("Leave tournament"),
        "leaveTournamentError": m23,
        "leftTournament": MessageLookupByLibrary.simpleMessage(
            "You have left the tournament"),
        "likedGamesTab": MessageLookupByLibrary.simpleMessage("Liked Games"),
        "listAllTournaments":
            MessageLookupByLibrary.simpleMessage("List Tournaments"),
        "listMyTeamsJoined": MessageLookupByLibrary.simpleMessage("My Teams"),
        "listMyTournaments":
            MessageLookupByLibrary.simpleMessage("My Tournaments"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "location": m24,
        "logIn": MessageLookupByLibrary.simpleMessage("Log In"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to log out?"),
        "logs": MessageLookupByLibrary.simpleMessage("Logs"),
        "longitude": MessageLookupByLibrary.simpleMessage("Longitude"),
        "matchDetails": MessageLookupByLibrary.simpleMessage("Match Details"),
        "membersAndTournaments": m25,
        "membersOfTeam": m26,
        "modifyGameButton": MessageLookupByLibrary.simpleMessage("Modify Game"),
        "moreTagsCount": m27,
        "mustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "You must be logged in to view your tournaments"),
        "mustBeLoggedInToUpvote": MessageLookupByLibrary.simpleMessage(
            "You must be logged in to upvote"),
        "mustBeLoggedInToViewBracket": MessageLookupByLibrary.simpleMessage(
            "You must be logged in to view your bracket"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "nameIsRequired":
            MessageLookupByLibrary.simpleMessage("Name is required"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noFriendsFound":
            MessageLookupByLibrary.simpleMessage("No friends found"),
        "noGamesAvailable":
            MessageLookupByLibrary.simpleMessage("No games available."),
        "noLikeToDelete":
            MessageLookupByLibrary.simpleMessage("No like to delete"),
        "noLikedGames":
            MessageLookupByLibrary.simpleMessage("No liked games found"),
        "noRatingFetched":
            MessageLookupByLibrary.simpleMessage("No rating fetched"),
        "noTeamsAvailable":
            MessageLookupByLibrary.simpleMessage("No teams available."),
        "noTeamsAvailableForUser": MessageLookupByLibrary.simpleMessage(
            "No teams available for the current user."),
        "noTeamsFoundForUser":
            MessageLookupByLibrary.simpleMessage("No teams found for the user"),
        "noTournamentsForGame": MessageLookupByLibrary.simpleMessage(
            "No tournaments for this game"),
        "noTournamentsFound":
            MessageLookupByLibrary.simpleMessage("No tournaments found"),
        "noUsersFound": MessageLookupByLibrary.simpleMessage("No users found"),
        "noWinnerYet": MessageLookupByLibrary.simpleMessage("No winner yet"),
        "notificationDeleted":
            MessageLookupByLibrary.simpleMessage("Notification deleted"),
        "notificationScreenTitle":
            MessageLookupByLibrary.simpleMessage("Notifications"),
        "notificationScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Welcome to the Notification screen!"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "numberOfPlayers":
            MessageLookupByLibrary.simpleMessage("Number of Players"),
        "numberOfPlayersIsRequired": MessageLookupByLibrary.simpleMessage(
            "Number of Players is required"),
        "numberOfPlayersPerTeam":
            MessageLookupByLibrary.simpleMessage("Number of Players per Team"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "orLoginWith": MessageLookupByLibrary.simpleMessage("Or login with"),
        "participants": MessageLookupByLibrary.simpleMessage("Participants:"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordResetEmailSent":
            MessageLookupByLibrary.simpleMessage("Password reset email sent"),
        "passwordResetSuccessful":
            MessageLookupByLibrary.simpleMessage("Password reset successful"),
        "photoLibrary": MessageLookupByLibrary.simpleMessage("Photo Library"),
        "pleaseEnterDescription":
            MessageLookupByLibrary.simpleMessage("Please enter a description"),
        "pleaseEnterEndDate":
            MessageLookupByLibrary.simpleMessage("Please enter an end date"),
        "pleaseEnterGameDescription": MessageLookupByLibrary.simpleMessage(
            "Please enter the game description"),
        "pleaseEnterGameId":
            MessageLookupByLibrary.simpleMessage("Please enter a game ID"),
        "pleaseEnterGameName":
            MessageLookupByLibrary.simpleMessage("Please enter the game name"),
        "pleaseEnterIfTournamentIsPrivate":
            MessageLookupByLibrary.simpleMessage(
                "Please enter if the tournament is private"),
        "pleaseEnterImageUrl":
            MessageLookupByLibrary.simpleMessage("Please enter an image URL"),
        "pleaseEnterLatitude":
            MessageLookupByLibrary.simpleMessage("Please enter a latitude"),
        "pleaseEnterLocation":
            MessageLookupByLibrary.simpleMessage("Please enter a location"),
        "pleaseEnterLongitude":
            MessageLookupByLibrary.simpleMessage("Please enter a longitude"),
        "pleaseEnterName":
            MessageLookupByLibrary.simpleMessage("Please enter a name"),
        "pleaseEnterNumberOfPlayers": MessageLookupByLibrary.simpleMessage(
            "Please enter the number of players"),
        "pleaseEnterStartDate":
            MessageLookupByLibrary.simpleMessage("Please enter a start date"),
        "pleaseEnterTags":
            MessageLookupByLibrary.simpleMessage("Please enter the tags"),
        "pleaseEnterTournamentDescription":
            MessageLookupByLibrary.simpleMessage(
                "Please enter the tournament description"),
        "pleaseEnterTournamentName": MessageLookupByLibrary.simpleMessage(
            "Please enter the tournament name"),
        "pleaseFillRequiredFields": MessageLookupByLibrary.simpleMessage(
            "Please fill in all required fields and select dates and times"),
        "popularGamesTitle":
            MessageLookupByLibrary.simpleMessage("Popular Games"),
        "pouleBrackets": MessageLookupByLibrary.simpleMessage("Pool Brackets"),
        "poulesTitle": MessageLookupByLibrary.simpleMessage("Tournament Pools"),
        "private": MessageLookupByLibrary.simpleMessage("Private"),
        "profileScreenTitle": MessageLookupByLibrary.simpleMessage("Profile"),
        "profileScreenWelcome": m28,
        "profileTab": MessageLookupByLibrary.simpleMessage("Profile"),
        "profileUpdated":
            MessageLookupByLibrary.simpleMessage("Profile updated"),
        "proposeToClose":
            MessageLookupByLibrary.simpleMessage("Propose to close"),
        "ratingCannotBeZero":
            MessageLookupByLibrary.simpleMessage("Rating cannot be zero"),
        "ratingFetchedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Rating fetched successfully"),
        "ratingSavedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Rating saved successfully"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "removedFromGameList":
            MessageLookupByLibrary.simpleMessage("Game removed from your list"),
        "resendCode": MessageLookupByLibrary.simpleMessage("Resend code"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
        "resourceNotFound404":
            MessageLookupByLibrary.simpleMessage("Resource not found (404)"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "score": MessageLookupByLibrary.simpleMessage("Score"),
        "searchTags": MessageLookupByLibrary.simpleMessage("Search tags"),
        "searchUser": MessageLookupByLibrary.simpleMessage("Search User"),
        "selectEndDate":
            MessageLookupByLibrary.simpleMessage("Select End Date"),
        "selectStartDate":
            MessageLookupByLibrary.simpleMessage("Select Start Date"),
        "selectTeamToJoin":
            MessageLookupByLibrary.simpleMessage("Select a Team to Join"),
        "selectTeamToLeave":
            MessageLookupByLibrary.simpleMessage("Select a Team to Leave"),
        "sendResetEmail":
            MessageLookupByLibrary.simpleMessage("Send Reset Email"),
        "sort": MessageLookupByLibrary.simpleMessage("SORT"),
        "sortAToZ": MessageLookupByLibrary.simpleMessage("Sort A-Z"),
        "sortZToA": MessageLookupByLibrary.simpleMessage("Sort Z-A"),
        "start": m29,
        "startDate": m30,
        "startDateIsRequired":
            MessageLookupByLibrary.simpleMessage("Start Date is required"),
        "startDateTime":
            MessageLookupByLibrary.simpleMessage("Start Date & Time"),
        "status": MessageLookupByLibrary.simpleMessage("Status"),
        "tags": MessageLookupByLibrary.simpleMessage("Tags"),
        "team": MessageLookupByLibrary.simpleMessage("Team"),
        "team1Score": MessageLookupByLibrary.simpleMessage("Team 1 Score"),
        "team2Score": MessageLookupByLibrary.simpleMessage("Team 2 Score"),
        "teamAlreadyInTournament": MessageLookupByLibrary.simpleMessage(
            "Team already in this tournament"),
        "teamCreatedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Team created successfully"),
        "teamDeleted": m31,
        "teamLeft": m32,
        "teamNotRegistered": MessageLookupByLibrary.simpleMessage(
            "This team is not registered in the tournament"),
        "teamPlayersCount": m33,
        "totalGames": MessageLookupByLibrary.simpleMessage("Total Games"),
        "tournamentAdded":
            MessageLookupByLibrary.simpleMessage("Tournament added"),
        "tournamentCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Tournament created successfully"),
        "tournamentEndDate": m34,
        "tournamentParticipants":
            MessageLookupByLibrary.simpleMessage("Tournament Participants"),
        "tournamentScreenTitle":
            MessageLookupByLibrary.simpleMessage("Tournaments"),
        "tournamentScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Welcome to the Tournament Screen!"),
        "tournamentStartDate": m35,
        "tournamentUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Tournament updated successfully"),
        "tournaments": MessageLookupByLibrary.simpleMessage("Tournaments"),
        "trendingTournamentsTitle":
            MessageLookupByLibrary.simpleMessage("Trending Tournaments"),
        "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "unknownError": m36,
        "unknownJoinError": MessageLookupByLibrary.simpleMessage(
            "Error joining the tournament"),
        "unknownPage": MessageLookupByLibrary.simpleMessage("Unknown Page"),
        "unknownState": MessageLookupByLibrary.simpleMessage("Unknown state"),
        "updateMatch": MessageLookupByLibrary.simpleMessage("Update Match"),
        "updateScore": MessageLookupByLibrary.simpleMessage("Update Score"),
        "upvoteAdded": MessageLookupByLibrary.simpleMessage("Upvote added"),
        "upvoteRemoved": MessageLookupByLibrary.simpleMessage("Upvote removed"),
        "upvotes": MessageLookupByLibrary.simpleMessage("Upvotes:"),
        "userKickedSuccess": m37,
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "users": MessageLookupByLibrary.simpleMessage("Users"),
        "validate": MessageLookupByLibrary.simpleMessage("Validate"),
        "verificationCodeSent": m38,
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "viewAll": MessageLookupByLibrary.simpleMessage("View All"),
        "viewAllParticipants":
            MessageLookupByLibrary.simpleMessage("View all participants"),
        "viewBrackets": MessageLookupByLibrary.simpleMessage("View Brackets"),
        "viewDetails": MessageLookupByLibrary.simpleMessage("View Details"),
        "viewGames": MessageLookupByLibrary.simpleMessage("View games"),
        "vs": MessageLookupByLibrary.simpleMessage("VS"),
        "waiting": MessageLookupByLibrary.simpleMessage("Waiting"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome to UrEsport"),
        "winner": MessageLookupByLibrary.simpleMessage("Winner"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("You are not logged in"),
        "youMustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "You must be logged in to follow this game"),
        "yourRating": MessageLookupByLibrary.simpleMessage("Your rating:")
      };
}
