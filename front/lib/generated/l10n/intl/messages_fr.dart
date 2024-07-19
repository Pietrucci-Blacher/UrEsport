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

  static String m0(date) => "Fin : ${date}";

  static String m1(error) => "Erreur lors du suivi du jeu : ${error}";

  static String m2(error) => "Erreur : ${error}";

  static String m3(error) =>
      "Erreur lors de l\'arrêt du suivi du jeu : ${error}";

  static String m4(count) => "Filtres (${count})";

  static String m5(count) => "+${count} de plus";

  static String m6(username) => "Bienvenue sur votre profil, ${username} !";

  static String m7(date) => "Début : ${date}";

  static String m8(email) => "Un code de vérification a été envoyé à ${email}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "actions": MessageLookupByLibrary.simpleMessage("Actions"),
        "activeTournaments":
            MessageLookupByLibrary.simpleMessage("Tournois actifs"),
        "activeUsers":
            MessageLookupByLibrary.simpleMessage("Utilisateurs actifs"),
        "addedToGameList":
            MessageLookupByLibrary.simpleMessage("Jeu ajouté à votre liste"),
        "alphabeticalAZ":
            MessageLookupByLibrary.simpleMessage("Alphabétique (A-Z)"),
        "alphabeticalZA":
            MessageLookupByLibrary.simpleMessage("Alphabétique (Z-A)"),
        "anErrorOccurred": MessageLookupByLibrary.simpleMessage(
            "Une erreur s\'est produite !"),
        "appTitle": MessageLookupByLibrary.simpleMessage("UrEsport"),
        "applyFilters":
            MessageLookupByLibrary.simpleMessage("Appliquer les filtres"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "cancelEditing":
            MessageLookupByLibrary.simpleMessage("Annuler l\'édition"),
        "closeButton": MessageLookupByLibrary.simpleMessage("Fermer"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
        "confirmDeleteGame": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous sûr de vouloir supprimer ce jeu ?"),
        "dangerZone": MessageLookupByLibrary.simpleMessage("Zone de danger"),
        "dashboard": MessageLookupByLibrary.simpleMessage("Tableau de bord"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Supprimer le compte"),
        "deleteGame": MessageLookupByLibrary.simpleMessage("Supprimer le jeu"),
        "deleteGameButton":
            MessageLookupByLibrary.simpleMessage("Supprimer le jeu"),
        "editProfile":
            MessageLookupByLibrary.simpleMessage("Modifier le profil"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "end": m0,
        "errorFollowingGame": m1,
        "errorLoading": MessageLookupByLibrary.simpleMessage(
            "Erreur de chargement des données"),
        "errorLoadingTournaments": m2,
        "errorUnfollowingGame": m3,
        "filterAndSort":
            MessageLookupByLibrary.simpleMessage("Filtrer et trier"),
        "filterByTags":
            MessageLookupByLibrary.simpleMessage("FILTRER PAR TAGS"),
        "filters": m4,
        "firstName": MessageLookupByLibrary.simpleMessage("Prénom"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Mot de passe oublié ?"),
        "gameButton":
            MessageLookupByLibrary.simpleMessage("Voir tout les jeux"),
        "gameDescription":
            MessageLookupByLibrary.simpleMessage("Description du jeu"),
        "gameDetailPageTitle":
            MessageLookupByLibrary.simpleMessage("Détails du jeu"),
        "gameScreenTitle": MessageLookupByLibrary.simpleMessage("Jeux"),
        "gameScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran des jeux !"),
        "games": MessageLookupByLibrary.simpleMessage("Jeux"),
        "homeScreenTitle": MessageLookupByLibrary.simpleMessage("Accueil"),
        "homeScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran d\'accueil !"),
        "inviteButton": MessageLookupByLibrary.simpleMessage("Inviter"),
        "inviteError": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de l\'invitation"),
        "inviteSuccess":
            MessageLookupByLibrary.simpleMessage("Vous avez bien été invité"),
        "joinButton": MessageLookupByLibrary.simpleMessage("Rejoindre"),
        "lastName": MessageLookupByLibrary.simpleMessage("Nom"),
        "latestMessage":
            MessageLookupByLibrary.simpleMessage("Dernier message"),
        "listAllTournaments":
            MessageLookupByLibrary.simpleMessage("Liste tournois"),
        "listMyTeamsJoined":
            MessageLookupByLibrary.simpleMessage("Mes équipes"),
        "listMyTournaments":
            MessageLookupByLibrary.simpleMessage("Mes tournois"),
        "logIn": MessageLookupByLibrary.simpleMessage("Connexion"),
        "login": MessageLookupByLibrary.simpleMessage("Connexion"),
        "logout": MessageLookupByLibrary.simpleMessage("Déconnexion"),
        "logs": MessageLookupByLibrary.simpleMessage("Journaux"),
        "modifyGameButton":
            MessageLookupByLibrary.simpleMessage("Modifier le jeu"),
        "moreTagsCount": m5,
        "mustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Vous devez être connecté pour voir vos tournois"),
        "noGamesAvailable":
            MessageLookupByLibrary.simpleMessage("Aucun jeu disponible."),
        "noLikeToDelete":
            MessageLookupByLibrary.simpleMessage("Aucun like à supprimer"),
        "noTournamentsForGame":
            MessageLookupByLibrary.simpleMessage("Aucun tournoi pour ce jeu"),
        "noTournamentsFound":
            MessageLookupByLibrary.simpleMessage("Aucun tournoi trouvé"),
        "notificationScreenTitle":
            MessageLookupByLibrary.simpleMessage("Notifications"),
        "notificationScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran des notifications !"),
        "orLoginWith":
            MessageLookupByLibrary.simpleMessage("Ou connectez-vous avec"),
        "password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "passwordResetEmailSent": MessageLookupByLibrary.simpleMessage(
            "E-mail de réinitialisation du mot de passe envoyé"),
        "passwordResetSuccessful": MessageLookupByLibrary.simpleMessage(
            "Réinitialisation du mot de passe réussie"),
        "popularGamesTitle":
            MessageLookupByLibrary.simpleMessage("Jeux populaires"),
        "profileScreenTitle": MessageLookupByLibrary.simpleMessage("Profil"),
        "profileScreenWelcome": m6,
        "register": MessageLookupByLibrary.simpleMessage("Inscription"),
        "removedFromGameList":
            MessageLookupByLibrary.simpleMessage("Jeu retiré de votre liste"),
        "resendCode":
            MessageLookupByLibrary.simpleMessage("Ré-envoyer le code"),
        "reset": MessageLookupByLibrary.simpleMessage("Réinitialiser"),
        "resetPassword": MessageLookupByLibrary.simpleMessage(
            "Réinitialiser le mot de passe"),
        "save": MessageLookupByLibrary.simpleMessage("Enregistrer"),
        "searchTags":
            MessageLookupByLibrary.simpleMessage("Rechercher des tags"),
        "sendResetEmail": MessageLookupByLibrary.simpleMessage(
            "Envoyer l\'email de réinitialisation"),
        "sort": MessageLookupByLibrary.simpleMessage("TRIER"),
        "start": m7,
        "tags": MessageLookupByLibrary.simpleMessage("Tags"),
        "totalGames": MessageLookupByLibrary.simpleMessage("Jeux totaux"),
        "tournamentScreenTitle":
            MessageLookupByLibrary.simpleMessage("Tournois"),
        "tournamentScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran des tournois !"),
        "tournaments": MessageLookupByLibrary.simpleMessage("Tournois"),
        "trendingTournamentsTitle":
            MessageLookupByLibrary.simpleMessage("Tournois en tendance"),
        "unknownPage": MessageLookupByLibrary.simpleMessage("Page inconnue"),
        "username": MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
        "users": MessageLookupByLibrary.simpleMessage("Utilisateurs"),
        "verificationCodeSent": m8,
        "verify": MessageLookupByLibrary.simpleMessage("Vérifier"),
        "viewAll": MessageLookupByLibrary.simpleMessage("Afficher tout"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bienvenue sur UrEsport"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("Vous n\'êtes pas connecté"),
        "youMustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Vous devez être connecté pour suivre ce jeu")
      };
}
