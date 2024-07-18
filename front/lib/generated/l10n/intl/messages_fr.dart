// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(friendName) =>
      "Voulez-vous vraiment supprimer ${friendName} de vos amis ?";

  static String m1(username) =>
      "Are you sure you want to kick ${username} from the team?";

  static String m2(teamName) =>
      "Are you sure you want to delete the team ${teamName}?";

  static String m3(date) => "End: ${date}";

  static String m4(date) => "End Date: ${date}";

  static String m5(e) => "Error checking if joined: ${e}";

  static String m6(e) => "Error checking if upvoted: ${e}";

  static String m7(error) => "Error following the game: ${error}";

  static String m8(error) => "Erreur lors du kick du user: ${error}";

  static String m9(e) => "Error loading current user: ${e}";

  static String m10(e) => "Error loading teams: ${e}";

  static String m11(error) => "Erreur : ${error}";

  static String m12(error) => "Error unfollowing the game: ${error}";

  static String m13(error) => "Failed to change upvote status: ${error}";

  static String m14(error) =>
      "Erreur lors de la création de l\'équipe: ${error}";

  static String m15(error) => "Erreur lors de la création du tournoi: ${error}";

  static String m16(error) => "Failed to delete the team: ${error}";

  static String m17(error) => "Failed to update tournament: ${error}";

  static String m18(count) => "Filtres (${count})";

  static String m19(gameName) => "Game: ${gameName}";

  static String m20(gameName) => "Game: ${gameName}";

  static String m21(error) => "Erreur lors du join: ${error}";

  static String m22(teamName) =>
      "Are you sure you want to leave the team ${teamName}?";

  static String m23(error) => "Erreur lors du départ du tournoi: ${error}";

  static String m24(location) => "Location: ${location}";

  static String m25(membersCount, tournamentsCount) =>
      "Members: ${membersCount} | Tournaments: ${tournamentsCount}";

  static String m26(teamName) => "Members of ${teamName}";

  static String m27(count) => "+${count} de plus";

  static String m28(username) => "Bienvenue sur votre profil, ${username} !";

  static String m29(date) => "Start: ${date}";

  static String m30(date) => "Start Date: ${date}";

  static String m31(teamName) => "Vous avez bien supprimé la team ${teamName}";

  static String m32(teamName) => "Vous avez bien quitté la team ${teamName}";

  static String m33(playersCount) =>
      "Nombre joueurs par teams: ${playersCount}";

  static String m34(date) => "End: ${date}";

  static String m35(date) => "Start: ${date}";

  static String m36(error) => "Erreur inconnue: ${error}";

  static String m37(username) => "${username} à bien était kick de la team";

  static String m38(email) =>
      "Un code de vérification a été envoyé à ${email}.";

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
            MessageLookupByLibrary.simpleMessage("Alphabétique (A-Z)"),
        "alphabeticalZA":
            MessageLookupByLibrary.simpleMessage("Alphabétique (Z-A)"),
        "alreadyJoinedTournament": MessageLookupByLibrary.simpleMessage(
            "Vous avez déjà rejoint le tournoi"),
        "anErrorOccurred": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite !"),
        "appTitle": MessageLookupByLibrary.simpleMessage("UrEsport"),
        "applyFilters":
            MessageLookupByLibrary.simpleMessage("Appliquer les filtres"),
        "bracket": MessageLookupByLibrary.simpleMessage("Bracket"),
        "bracketUpdated":
            MessageLookupByLibrary.simpleMessage("Bracket updated"),
        "camera": MessageLookupByLibrary.simpleMessage("Appareil photo"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "cancelClose": MessageLookupByLibrary.simpleMessage("Cancel Close"),
        "cancelCloseMatch":
            MessageLookupByLibrary.simpleMessage("Annuler la cloture"),
        "cancelEditing":
            MessageLookupByLibrary.simpleMessage("Annuler l\'édition"),
        "closeButton": MessageLookupByLibrary.simpleMessage("Fermer"),
        "closeMatch": MessageLookupByLibrary.simpleMessage("Close Match"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
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
        "dangerZone": MessageLookupByLibrary.simpleMessage("Zone de danger"),
        "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Supprimer le compte"),
        "deleteAccountConfirmation": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous sûr de vouloir supprimer votre compte ?"),
        "deleteGame": MessageLookupByLibrary.simpleMessage("Delete Game"),
        "deleteGameButton":
            MessageLookupByLibrary.simpleMessage("Supprimer le jeu"),
        "deleteTeamConfirmation": m2,
        "description": MessageLookupByLibrary.simpleMessage("Description:"),
        "descriptionGame": MessageLookupByLibrary.simpleMessage("Description:"),
        "descriptionIsRequired":
            MessageLookupByLibrary.simpleMessage("Description is required"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "editProfile":
            MessageLookupByLibrary.simpleMessage("Modifier le profil"),
        "editTournament":
            MessageLookupByLibrary.simpleMessage("Edit Tournament"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "end": m3,
        "endDate": m4,
        "endDateIsRequired":
            MessageLookupByLibrary.simpleMessage("End Date is required"),
        "endDateTime": MessageLookupByLibrary.simpleMessage("End Date & Time"),
        "enterResult": MessageLookupByLibrary.simpleMessage("Enter result for"),
        "errorAddingFriend": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de l\'ajout de l\'ami"),
        "errorAddingGame":
            MessageLookupByLibrary.simpleMessage("Error adding game"),
        "errorAddingTournament":
            MessageLookupByLibrary.simpleMessage("Error adding tournament"),
        "errorCheckingIfJoined": m5,
        "errorCheckingIfUpvoted": m6,
        "errorDeletingAccount": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la suppression du compte"),
        "errorFetchingLikedGames": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la récupération des jeux aimés"),
        "errorFetchingRating": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la récupération de la note"),
        "errorFollowingGame": m7,
        "errorKickingUser": m8,
        "errorLoading":
            MessageLookupByLibrary.simpleMessage("Error loading data"),
        "errorLoadingCurrentUser": m9,
        "errorLoadingTeams": m10,
        "errorLoadingTournaments": m11,
        "errorPickingImage": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la sélection de l\'image"),
        "errorSavingProfile": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la sauvegarde du profil"),
        "errorSavingRating": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de l\'enregistrement de la note"),
        "errorUnfollowingGame": m12,
        "errorUploadingProfileImage": MessageLookupByLibrary.simpleMessage(
            "Erreur lors du téléchargement de l\'image de profil"),
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
        "favorites": MessageLookupByLibrary.simpleMessage("Favoris"),
        "filterAndSort":
            MessageLookupByLibrary.simpleMessage("Filtrer et trier"),
        "filterByTags":
            MessageLookupByLibrary.simpleMessage("FILTRER PAR TAGS"),
        "filters": m18,
        "firstName": MessageLookupByLibrary.simpleMessage("Prénom"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Mot de passe oublié ?"),
        "friendAddedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Ami ajouté avec succès"),
        "friendAlreadyAdded":
            MessageLookupByLibrary.simpleMessage("Ami déjà ajouté"),
        "friendDetails":
            MessageLookupByLibrary.simpleMessage("Détails de l\'ami"),
        "friends": MessageLookupByLibrary.simpleMessage("Amis"),
        "friendsTab": MessageLookupByLibrary.simpleMessage("Amis"),
        "game": m19,
        "gameAdded": MessageLookupByLibrary.simpleMessage("Game added"),
        "gameButton":
            MessageLookupByLibrary.simpleMessage("Voir tout les jeux"),
        "gameDescription":
            MessageLookupByLibrary.simpleMessage("Game Description"),
        "gameDetailPageTitle":
            MessageLookupByLibrary.simpleMessage("Game Details"),
        "gameId": MessageLookupByLibrary.simpleMessage("Game ID"),
        "gameIdIsRequired":
            MessageLookupByLibrary.simpleMessage("Game ID is required"),
        "gameName": m20,
        "gameScreenTitle": MessageLookupByLibrary.simpleMessage("Jeux"),
        "gameScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran des jeux !"),
        "games": MessageLookupByLibrary.simpleMessage("Games"),
        "generateBracket":
            MessageLookupByLibrary.simpleMessage("Générer le bracket"),
        "homeScreenTitle": MessageLookupByLibrary.simpleMessage("Accueil"),
        "homeScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran d\'accueil !"),
        "imageUrl": MessageLookupByLibrary.simpleMessage("Image URL"),
        "inviteButton": MessageLookupByLibrary.simpleMessage("Inviter"),
        "inviteError": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de l\'invitation"),
        "inviteSuccess":
            MessageLookupByLibrary.simpleMessage("Vous avez bien été invité"),
        "joinButton": MessageLookupByLibrary.simpleMessage("Rejoindre"),
        "joinError": m21,
        "joinTournament":
            MessageLookupByLibrary.simpleMessage("Rejoindre le tournoi"),
        "joinedTournament": MessageLookupByLibrary.simpleMessage(
            "Vous avez bien rejoint le tournoi"),
        "kick": MessageLookupByLibrary.simpleMessage("Kick"),
        "lastName": MessageLookupByLibrary.simpleMessage("Nom"),
        "latestMessage": MessageLookupByLibrary.simpleMessage("Latest Message"),
        "latitude": MessageLookupByLibrary.simpleMessage("Latitude"),
        "leave": MessageLookupByLibrary.simpleMessage("Leave"),
        "leaveTeamConfirmation": m22,
        "leaveTournament":
            MessageLookupByLibrary.simpleMessage("Quitter le tournoi"),
        "leaveTournamentError": m23,
        "leftTournament":
            MessageLookupByLibrary.simpleMessage("Vous avez quitté le tournoi"),
        "likedGamesTab": MessageLookupByLibrary.simpleMessage("Jeux aimés"),
        "listAllTournaments":
            MessageLookupByLibrary.simpleMessage("Liste tournois"),
        "listMyTeamsJoined":
            MessageLookupByLibrary.simpleMessage("Mes équipes"),
        "listMyTournaments":
            MessageLookupByLibrary.simpleMessage("Mes Tournois"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "location": m24,
        "logIn": MessageLookupByLibrary.simpleMessage("Connexion"),
        "login": MessageLookupByLibrary.simpleMessage("Connexion"),
        "logout": MessageLookupByLibrary.simpleMessage("Déconnexion"),
        "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous sûr de vouloir vous déconnecter ?"),
        "logs": MessageLookupByLibrary.simpleMessage("Logs"),
        "longitude": MessageLookupByLibrary.simpleMessage("Longitude"),
        "matchDetails": MessageLookupByLibrary.simpleMessage("Match Details"),
        "membersAndTournaments": m25,
        "membersOfTeam": m26,
        "modifyGameButton":
            MessageLookupByLibrary.simpleMessage("Modifier le jeu"),
        "moreTagsCount": m27,
        "mustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Vous devez être connecté pour voir vos tournois"),
        "mustBeLoggedInToUpvote": MessageLookupByLibrary.simpleMessage(
            "You must be logged in to upvote"),
        "mustBeLoggedInToViewBracket": MessageLookupByLibrary.simpleMessage(
            "You must be logged in to view your bracket"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "nameIsRequired":
            MessageLookupByLibrary.simpleMessage("Name is required"),
        "no": MessageLookupByLibrary.simpleMessage("Non"),
        "noFriendsFound":
            MessageLookupByLibrary.simpleMessage("No friends found"),
        "noGamesAvailable":
            MessageLookupByLibrary.simpleMessage("Aucun jeu disponible."),
        "noLikeToDelete":
            MessageLookupByLibrary.simpleMessage("No like to delete"),
        "noLikedGames":
            MessageLookupByLibrary.simpleMessage("Aucun jeu aimé trouvé"),
        "noRatingFetched": MessageLookupByLibrary.simpleMessage(
            "Aucune note n\'a été récupérée"),
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
            MessageLookupByLibrary.simpleMessage("Notification supprimée"),
        "notificationScreenTitle":
            MessageLookupByLibrary.simpleMessage("Notifications"),
        "notificationScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran des notifications !"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "numberOfPlayers":
            MessageLookupByLibrary.simpleMessage("Number of Players"),
        "numberOfPlayersIsRequired": MessageLookupByLibrary.simpleMessage(
            "Number of Players is required"),
        "numberOfPlayersPerTeam":
            MessageLookupByLibrary.simpleMessage("Number of Players per Team"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "orLoginWith":
            MessageLookupByLibrary.simpleMessage("Ou connectez-vous avec"),
        "participants": MessageLookupByLibrary.simpleMessage("Participants:"),
        "password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "passwordResetEmailSent": MessageLookupByLibrary.simpleMessage(
            "E-mail de réinitialisation du mot de passe envoyé"),
        "passwordResetSuccessful": MessageLookupByLibrary.simpleMessage(
            "Réinitialisation du mot de passe réussie"),
        "photoLibrary":
            MessageLookupByLibrary.simpleMessage("Bibliothèque de photos"),
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
            MessageLookupByLibrary.simpleMessage("Jeux populaires"),
        "pouleBrackets":
            MessageLookupByLibrary.simpleMessage("Brackets des Poules"),
        "poulesTitle":
            MessageLookupByLibrary.simpleMessage("Poules de Tournois"),
        "private": MessageLookupByLibrary.simpleMessage("Private"),
        "profileScreenTitle": MessageLookupByLibrary.simpleMessage("Profil"),
        "profileScreenWelcome": m28,
        "profileTab": MessageLookupByLibrary.simpleMessage("Profil"),
        "profileUpdated":
            MessageLookupByLibrary.simpleMessage("Profil mis à jour"),
        "proposeToClose":
            MessageLookupByLibrary.simpleMessage("Propose to close"),
        "ratingCannotBeZero": MessageLookupByLibrary.simpleMessage(
            "La note ne peut pas être zéro"),
        "ratingFetchedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Note récupérée avec succès"),
        "ratingSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Note enregistrée avec succès"),
        "register": MessageLookupByLibrary.simpleMessage("Inscription"),
        "removedFromGameList":
            MessageLookupByLibrary.simpleMessage("Game removed from your list"),
        "resendCode":
            MessageLookupByLibrary.simpleMessage("Ré-envoyer le code"),
        "reset": MessageLookupByLibrary.simpleMessage("Réinitialiser"),
        "resetPassword": MessageLookupByLibrary.simpleMessage(
            "Réinitialiser le mot de passe"),
        "resourceNotFound404":
            MessageLookupByLibrary.simpleMessage("Ressource non trouvée (404)"),
        "save": MessageLookupByLibrary.simpleMessage("Enregistrer"),
        "score": MessageLookupByLibrary.simpleMessage("Score"),
        "searchTags":
            MessageLookupByLibrary.simpleMessage("Rechercher des tags"),
        "searchUser": MessageLookupByLibrary.simpleMessage("Search User"),
        "selectEndDate":
            MessageLookupByLibrary.simpleMessage("Select End Date"),
        "selectStartDate":
            MessageLookupByLibrary.simpleMessage("Select Start Date"),
        "selectTeamToJoin":
            MessageLookupByLibrary.simpleMessage("Select a Team to Join"),
        "selectTeamToLeave":
            MessageLookupByLibrary.simpleMessage("Select a Team to Leave"),
        "sendResetEmail": MessageLookupByLibrary.simpleMessage(
            "Envoyer l\'email de réinitialisation"),
        "sort": MessageLookupByLibrary.simpleMessage("TRIER"),
        "sortAToZ": MessageLookupByLibrary.simpleMessage("Trier A-Z"),
        "sortZToA": MessageLookupByLibrary.simpleMessage("Trier Z-A"),
        "start": m29,
        "startDate": m30,
        "startDateIsRequired":
            MessageLookupByLibrary.simpleMessage("Start Date is required"),
        "startDateTime":
            MessageLookupByLibrary.simpleMessage("Start Date & Time"),
        "status": MessageLookupByLibrary.simpleMessage("Status"),
        "tags": MessageLookupByLibrary.simpleMessage(
            "Tags (comma or space separated)"),
        "team": MessageLookupByLibrary.simpleMessage("Team"),
        "team1Score": MessageLookupByLibrary.simpleMessage("Score team 1"),
        "team2Score": MessageLookupByLibrary.simpleMessage("Score team 2"),
        "teamAlreadyInTournament": MessageLookupByLibrary.simpleMessage(
            "Team already in this tournament"),
        "teamCreatedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Équipe créée avec succès"),
        "teamDeleted": m31,
        "teamLeft": m32,
        "teamNotRegistered": MessageLookupByLibrary.simpleMessage(
            "Cette team n\'est pas inscrite dans le tournoi"),
        "teamPlayersCount": m33,
        "totalGames": MessageLookupByLibrary.simpleMessage("Total Games"),
        "tournamentAdded":
            MessageLookupByLibrary.simpleMessage("Tournament added"),
        "tournamentCreatedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Tournoi créé avec succès"),
        "tournamentEndDate": m34,
        "tournamentParticipants":
            MessageLookupByLibrary.simpleMessage("Participants du tournoi"),
        "tournamentScreenTitle":
            MessageLookupByLibrary.simpleMessage("Tournois"),
        "tournamentScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran des tournois !"),
        "tournamentStartDate": m35,
        "tournamentUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Tournament updated successfully"),
        "tournaments": MessageLookupByLibrary.simpleMessage("Tournaments"),
        "trendingTournamentsTitle":
            MessageLookupByLibrary.simpleMessage("Tournois en tendance"),
        "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "unknownError": m36,
        "unknownJoinError": MessageLookupByLibrary.simpleMessage(
            "Erreur pour rejoindre le tournoi"),
        "unknownPage": MessageLookupByLibrary.simpleMessage("Unknown page"),
        "unknownState": MessageLookupByLibrary.simpleMessage("Unknown state"),
        "updateMatch": MessageLookupByLibrary.simpleMessage("Update Match"),
        "updateScore": MessageLookupByLibrary.simpleMessage("Update Score"),
        "upvoteAdded": MessageLookupByLibrary.simpleMessage("Upvote ajouté"),
        "upvoteRemoved": MessageLookupByLibrary.simpleMessage("Upvote retiré"),
        "upvotes": MessageLookupByLibrary.simpleMessage("Upvotes:"),
        "userKickedSuccess": m37,
        "username": MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
        "users": MessageLookupByLibrary.simpleMessage("Users"),
        "validate": MessageLookupByLibrary.simpleMessage("Valider"),
        "verificationCodeSent": m38,
        "verify": MessageLookupByLibrary.simpleMessage("Vérifier"),
        "viewAll": MessageLookupByLibrary.simpleMessage("Afficher tout"),
        "viewAllParticipants":
            MessageLookupByLibrary.simpleMessage("Voir tous les participants"),
        "viewBrackets":
            MessageLookupByLibrary.simpleMessage("Voir les Brackets"),
        "viewDetails": MessageLookupByLibrary.simpleMessage("Voir les détails"),
        "viewGames": MessageLookupByLibrary.simpleMessage("Voir les jeux"),
        "vs": MessageLookupByLibrary.simpleMessage("VS"),
        "waiting": MessageLookupByLibrary.simpleMessage("waiting"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bienvenue sur UrEsport"),
        "winner": MessageLookupByLibrary.simpleMessage("Winner"),
        "yes": MessageLookupByLibrary.simpleMessage("Oui"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("Vous n\'êtes pas connecté"),
        "youMustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "You must be logged in to follow this game"),
        "yourRating": MessageLookupByLibrary.simpleMessage("Votre note:")
      };
}
