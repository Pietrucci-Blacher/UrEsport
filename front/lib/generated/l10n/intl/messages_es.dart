// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(friendName) =>
      "Voulez-vous vraiment supprimer ${friendName} de vos amis ?";

  static String m1(username) =>
      "Are you sure you want to kick ${username} from the team?";

  static String m2(teamName) =>
      "Are you sure you want to delete the team ${teamName}?";

  static String m3(date) => "Fin: ${date}";

  static String m4(date) => "End Date: ${date}";

  static String m5(e) => "Error checking if joined: ${e}";

  static String m6(e) => "Error checking if upvoted: ${e}";

  static String m7(error) => "Error al seguir el juego: ${error}";

  static String m8(error) => "Erreur lors du kick du user: ${error}";

  static String m9(e) => "Error loading current user: ${e}";

  static String m10(e) => "Error loading teams: ${e}";

  static String m11(error) => "Error: ${error}";

  static String m12(error) => "Error al dejar de seguir el juego: ${error}";

  static String m13(error) => "Failed to change upvote status: ${error}";

  static String m14(error) =>
      "Erreur lors de la création de l\'équipe: ${error}";

  static String m15(error) => "Erreur lors de la création du tournoi: ${error}";

  static String m16(error) => "Failed to delete the team: ${error}";

  static String m17(error) => "Failed to update tournament: ${error}";

  static String m18(count) => "Filtros (${count})";

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

  static String m27(count) => "+${count} más";

  static String m28(username) => "¡Bienvenido a tu perfil, ${username}!";

  static String m29(date) => "Inicio: ${date}";

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
      "Se ha enviado un código de verificación a ${email}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "actions": MessageLookupByLibrary.simpleMessage("Acciones"),
        "activeTournaments":
            MessageLookupByLibrary.simpleMessage("Torneos activos"),
        "activeUsers": MessageLookupByLibrary.simpleMessage("Usuarios activos"),
        "addFriend": MessageLookupByLibrary.simpleMessage("Add Friend"),
        "addGame": MessageLookupByLibrary.simpleMessage("Add Game"),
        "addTeam": MessageLookupByLibrary.simpleMessage("Add Team"),
        "addTournament": MessageLookupByLibrary.simpleMessage("Add Tournament"),
        "addedToGameList":
            MessageLookupByLibrary.simpleMessage("Juego añadido a tu lista"),
        "alphabeticalAZ":
            MessageLookupByLibrary.simpleMessage("Alfabético (A-Z)"),
        "alphabeticalZA":
            MessageLookupByLibrary.simpleMessage("Alfabético (Z-A)"),
        "alreadyJoinedTournament": MessageLookupByLibrary.simpleMessage(
            "Vous avez déjà rejoint le tournoi"),
        "anErrorOccurred":
            MessageLookupByLibrary.simpleMessage("¡Se produjo un error!"),
        "appTitle": MessageLookupByLibrary.simpleMessage("UrEsport"),
        "applyFilters": MessageLookupByLibrary.simpleMessage("Aplicar filtros"),
        "bracket": MessageLookupByLibrary.simpleMessage("Bracket"),
        "bracketUpdated":
            MessageLookupByLibrary.simpleMessage("Bracket updated"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "cancelClose": MessageLookupByLibrary.simpleMessage("Cancel Close"),
        "cancelCloseMatch":
            MessageLookupByLibrary.simpleMessage("Annuler la cloture"),
        "cancelEditing":
            MessageLookupByLibrary.simpleMessage("Cancelar edición"),
        "closeButton": MessageLookupByLibrary.simpleMessage("Cerrar"),
        "closeMatch": MessageLookupByLibrary.simpleMessage("Close Match"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
        "confirmAction": MessageLookupByLibrary.simpleMessage("Confirm Action"),
        "confirmDeleteFriend": m0,
        "confirmDeleteGame": MessageLookupByLibrary.simpleMessage(
            "¿Estás seguro de que quieres eliminar este juego?"),
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
        "dangerZone": MessageLookupByLibrary.simpleMessage("Zona de peligro"),
        "dashboard": MessageLookupByLibrary.simpleMessage("Panel de control"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Eliminar cuenta"),
        "deleteGame": MessageLookupByLibrary.simpleMessage("Eliminar juego"),
        "deleteGameButton":
            MessageLookupByLibrary.simpleMessage("Eliminar el juego"),
        "deleteTeamConfirmation": m2,
        "description": MessageLookupByLibrary.simpleMessage("Description:"),
        "descriptionGame": MessageLookupByLibrary.simpleMessage("Description:"),
        "descriptionIsRequired":
            MessageLookupByLibrary.simpleMessage("Description is required"),
        "details": MessageLookupByLibrary.simpleMessage("Details"),
        "editProfile": MessageLookupByLibrary.simpleMessage("Editar perfil"),
        "editTournament":
            MessageLookupByLibrary.simpleMessage("Edit Tournament"),
        "email": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
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
        "errorFetchingRating": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la récupération de la note"),
        "errorFollowingGame": m7,
        "errorKickingUser": m8,
        "errorLoading":
            MessageLookupByLibrary.simpleMessage("Error al cargar los datos"),
        "errorLoadingCurrentUser": m9,
        "errorLoadingTeams": m10,
        "errorLoadingTournaments": m11,
        "errorSavingRating": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de l\'enregistrement de la note"),
        "errorUnfollowingGame": m12,
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
            MessageLookupByLibrary.simpleMessage("Filtrar y ordenar"),
        "filterByTags":
            MessageLookupByLibrary.simpleMessage("FILTRAR POR ETIQUETAS"),
        "filters": m18,
        "firstName": MessageLookupByLibrary.simpleMessage("Nombre"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("¿Olvidaste tu contraseña?"),
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
            MessageLookupByLibrary.simpleMessage("Ver todos los juegos"),
        "gameDescription":
            MessageLookupByLibrary.simpleMessage("Descripción del Juego"),
        "gameDetailPageTitle":
            MessageLookupByLibrary.simpleMessage("Detalles del Juego"),
        "gameId": MessageLookupByLibrary.simpleMessage("Game ID"),
        "gameIdIsRequired":
            MessageLookupByLibrary.simpleMessage("Game ID is required"),
        "gameName": m20,
        "gameScreenTitle": MessageLookupByLibrary.simpleMessage("Juegos"),
        "gameScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de juegos!"),
        "games": MessageLookupByLibrary.simpleMessage("Juegos"),
        "generateBracket":
            MessageLookupByLibrary.simpleMessage("Générer le bracket"),
        "homeScreenTitle": MessageLookupByLibrary.simpleMessage("Inicio"),
        "homeScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de inicio!"),
        "imageUrl": MessageLookupByLibrary.simpleMessage("Image URL"),
        "inviteButton": MessageLookupByLibrary.simpleMessage("Invitar"),
        "inviteError":
            MessageLookupByLibrary.simpleMessage("Error de invitación"),
        "inviteSuccess":
            MessageLookupByLibrary.simpleMessage("Ha sido invitado"),
        "joinButton": MessageLookupByLibrary.simpleMessage("Unirse"),
        "joinError": m21,
        "joinTournament":
            MessageLookupByLibrary.simpleMessage("Rejoindre le tournoi"),
        "joinedTournament": MessageLookupByLibrary.simpleMessage(
            "Vous avez bien rejoint le tournoi"),
        "kick": MessageLookupByLibrary.simpleMessage("Kick"),
        "lastName": MessageLookupByLibrary.simpleMessage("Apellido"),
        "latestMessage": MessageLookupByLibrary.simpleMessage("Último mensaje"),
        "latitude": MessageLookupByLibrary.simpleMessage("Latitude"),
        "leave": MessageLookupByLibrary.simpleMessage("Leave"),
        "leaveTeamConfirmation": m22,
        "leaveTournament":
            MessageLookupByLibrary.simpleMessage("Quitter le tournoi"),
        "leaveTournamentError": m23,
        "leftTournament":
            MessageLookupByLibrary.simpleMessage("Vous avez quitté le tournoi"),
        "listAllTournaments":
            MessageLookupByLibrary.simpleMessage("Lista de torneos"),
        "listMyTeamsJoined":
            MessageLookupByLibrary.simpleMessage("Mis equipos"),
        "listMyTournaments":
            MessageLookupByLibrary.simpleMessage("Mis torneos"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "location": m24,
        "logIn": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
        "logs": MessageLookupByLibrary.simpleMessage("Registros"),
        "longitude": MessageLookupByLibrary.simpleMessage("Longitude"),
        "matchDetails": MessageLookupByLibrary.simpleMessage("Match Details"),
        "membersAndTournaments": m25,
        "membersOfTeam": m26,
        "modifyGameButton":
            MessageLookupByLibrary.simpleMessage("Modificar el juego"),
        "moreTagsCount": m27,
        "mustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Debes estar conectado para ver tus torneos"),
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
            MessageLookupByLibrary.simpleMessage("No hay juegos disponibles."),
        "noLikeToDelete": MessageLookupByLibrary.simpleMessage(
            "No hay me gusta para eliminar"),
        "noRatingFetched": MessageLookupByLibrary.simpleMessage(
            "Aucune note n\'a été récupérée"),
        "noTeamsAvailable":
            MessageLookupByLibrary.simpleMessage("No teams available."),
        "noTeamsAvailableForUser": MessageLookupByLibrary.simpleMessage(
            "No teams available for the current user."),
        "noTeamsFoundForUser":
            MessageLookupByLibrary.simpleMessage("No teams found for the user"),
        "noTournamentsForGame": MessageLookupByLibrary.simpleMessage(
            "No hay torneos para este juego"),
        "noTournamentsFound":
            MessageLookupByLibrary.simpleMessage("No se encontraron torneos"),
        "noUsersFound": MessageLookupByLibrary.simpleMessage("No users found"),
        "noWinnerYet": MessageLookupByLibrary.simpleMessage("No winner yet"),
        "notificationDeleted":
            MessageLookupByLibrary.simpleMessage("Notification supprimée"),
        "notificationScreenTitle":
            MessageLookupByLibrary.simpleMessage("Notificaciones"),
        "notificationScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de notificaciones!"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "numberOfPlayers":
            MessageLookupByLibrary.simpleMessage("Number of Players"),
        "numberOfPlayersIsRequired": MessageLookupByLibrary.simpleMessage(
            "Number of Players is required"),
        "numberOfPlayersPerTeam":
            MessageLookupByLibrary.simpleMessage("Number of Players per Team"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "orLoginWith":
            MessageLookupByLibrary.simpleMessage("O iniciar sesión con"),
        "participants": MessageLookupByLibrary.simpleMessage("Participants:"),
        "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
        "passwordResetEmailSent": MessageLookupByLibrary.simpleMessage(
            "Correo electrónico de restablecimiento de contraseña enviado"),
        "passwordResetSuccessful": MessageLookupByLibrary.simpleMessage(
            "Restablecimiento de contraseña exitoso"),
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
            MessageLookupByLibrary.simpleMessage("Juegos populares"),
        "pouleBrackets":
            MessageLookupByLibrary.simpleMessage("Brackets des Poules"),
        "poulesTitle":
            MessageLookupByLibrary.simpleMessage("Poules de Tournois"),
        "private": MessageLookupByLibrary.simpleMessage("Private"),
        "profileScreenTitle": MessageLookupByLibrary.simpleMessage("Perfil"),
        "profileScreenWelcome": m28,
        "proposeToClose":
            MessageLookupByLibrary.simpleMessage("Propose to close"),
        "ratingCannotBeZero": MessageLookupByLibrary.simpleMessage(
            "La note ne peut pas être zéro"),
        "ratingFetchedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Note récupérée avec succès"),
        "ratingSavedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Note enregistrée avec succès"),
        "register": MessageLookupByLibrary.simpleMessage("Registrarse"),
        "removedFromGameList":
            MessageLookupByLibrary.simpleMessage("Juego eliminado de tu lista"),
        "resendCode":
            MessageLookupByLibrary.simpleMessage("Reenviar el código"),
        "reset": MessageLookupByLibrary.simpleMessage("Restablecer"),
        "resetPassword":
            MessageLookupByLibrary.simpleMessage("Restablecer la contraseña"),
        "resourceNotFound404":
            MessageLookupByLibrary.simpleMessage("Ressource non trouvée (404)"),
        "save": MessageLookupByLibrary.simpleMessage("Guardar"),
        "score": MessageLookupByLibrary.simpleMessage("Score"),
        "searchTags": MessageLookupByLibrary.simpleMessage("Buscar etiquetas"),
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
            "Enviar correo de restablecimiento"),
        "sort": MessageLookupByLibrary.simpleMessage("ORDENAR"),
        "sortAToZ": MessageLookupByLibrary.simpleMessage("Trier A-Z"),
        "sortZToA": MessageLookupByLibrary.simpleMessage("Trier Z-A"),
        "start": m29,
        "startDate": m30,
        "startDateIsRequired":
            MessageLookupByLibrary.simpleMessage("Start Date is required"),
        "startDateTime":
            MessageLookupByLibrary.simpleMessage("Start Date & Time"),
        "status": MessageLookupByLibrary.simpleMessage("Status"),
        "tags": MessageLookupByLibrary.simpleMessage("Etiquetas"),
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
        "totalGames": MessageLookupByLibrary.simpleMessage("Juegos totales"),
        "tournamentAdded":
            MessageLookupByLibrary.simpleMessage("Tournament added"),
        "tournamentCreatedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Tournoi créé avec succès"),
        "tournamentEndDate": m34,
        "tournamentParticipants":
            MessageLookupByLibrary.simpleMessage("Participants du tournoi"),
        "tournamentScreenTitle":
            MessageLookupByLibrary.simpleMessage("Torneos"),
        "tournamentScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de torneos!"),
        "tournamentStartDate": m35,
        "tournamentUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Tournament updated successfully"),
        "tournaments": MessageLookupByLibrary.simpleMessage("Torneos"),
        "trendingTournamentsTitle":
            MessageLookupByLibrary.simpleMessage("Torneos en tendencia"),
        "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "unknownError": m36,
        "unknownJoinError": MessageLookupByLibrary.simpleMessage(
            "Erreur pour rejoindre le tournoi"),
        "unknownPage":
            MessageLookupByLibrary.simpleMessage("Página desconocida"),
        "unknownState": MessageLookupByLibrary.simpleMessage("Unknown state"),
        "updateMatch": MessageLookupByLibrary.simpleMessage("Update Match"),
        "updateScore": MessageLookupByLibrary.simpleMessage("Update Score"),
        "upvoteAdded": MessageLookupByLibrary.simpleMessage("Upvote ajouté"),
        "upvoteRemoved": MessageLookupByLibrary.simpleMessage("Upvote retiré"),
        "upvotes": MessageLookupByLibrary.simpleMessage("Upvotes:"),
        "userKickedSuccess": m37,
        "username": MessageLookupByLibrary.simpleMessage("Nombre de usuario"),
        "users": MessageLookupByLibrary.simpleMessage("Usuarios"),
        "validate": MessageLookupByLibrary.simpleMessage("Valider"),
        "verificationCodeSent": m38,
        "verify": MessageLookupByLibrary.simpleMessage("Verificar"),
        "viewAll": MessageLookupByLibrary.simpleMessage("Ver todo"),
        "viewAllParticipants":
            MessageLookupByLibrary.simpleMessage("Voir tous les participants"),
        "viewBrackets":
            MessageLookupByLibrary.simpleMessage("Voir les Brackets"),
        "viewDetails": MessageLookupByLibrary.simpleMessage("Ver detalles"),
        "viewGames": MessageLookupByLibrary.simpleMessage("Voir les jeux"),
        "vs": MessageLookupByLibrary.simpleMessage("VS"),
        "waiting": MessageLookupByLibrary.simpleMessage("waiting"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bienvenido a UrEsport"),
        "winner": MessageLookupByLibrary.simpleMessage("Winner"),
        "yes": MessageLookupByLibrary.simpleMessage("Oui"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("No has iniciado sesión"),
        "youMustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Debes estar conectado para seguir este juego"),
        "yourRating": MessageLookupByLibrary.simpleMessage("Votre note:")
      };
}
