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

  static String m0(count) => "Filtres (${count})";

  static String m1(count) => "+${count} de plus";

  static String m2(username) => "Bienvenue sur votre profil, ${username} !";

  static String m3(email) => "Un code de vérification a été envoyé à ${email}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
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
        "dangerZone": MessageLookupByLibrary.simpleMessage("Zone de danger"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Supprimer le compte"),
        "deleteGameButton":
            MessageLookupByLibrary.simpleMessage("Supprimer le jeux"),
        "editProfile":
            MessageLookupByLibrary.simpleMessage("Modifier le profil"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "filterAndSort":
            MessageLookupByLibrary.simpleMessage("Filtrer et trier"),
        "filterByTags":
            MessageLookupByLibrary.simpleMessage("FILTRER PAR TAGS"),
        "filters": m0,
        "firstName": MessageLookupByLibrary.simpleMessage("Prénom"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Mot de passe oublié ?"),
        "gameButton":
            MessageLookupByLibrary.simpleMessage("Voir tout les jeux"),
        "gameScreenTitle": MessageLookupByLibrary.simpleMessage("Jeux"),
        "gameScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran des jeux !"),
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
        "listAllTournaments":
            MessageLookupByLibrary.simpleMessage("Liste tournois"),
        "listMyTournaments":
            MessageLookupByLibrary.simpleMessage("Mes tournois"),
        "logIn": MessageLookupByLibrary.simpleMessage("Connexion"),
        "login": MessageLookupByLibrary.simpleMessage("Connexion"),
        "logout": MessageLookupByLibrary.simpleMessage("Déconnexion"),
        "modifyGameButton":
            MessageLookupByLibrary.simpleMessage("Modifier le jeux"),
        "moreTagsCount": m1,
        "mustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Vous devez être connecté pour voir vos tournois"),
        "noGamesAvailable":
            MessageLookupByLibrary.simpleMessage("Aucun jeu disponible."),
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
        "profileScreenWelcome": m2,
        "register": MessageLookupByLibrary.simpleMessage("Inscription"),
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
        "tournamentScreenTitle":
            MessageLookupByLibrary.simpleMessage("Tournois"),
        "tournamentScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran des tournois !"),
        "trendingTournamentsTitle":
            MessageLookupByLibrary.simpleMessage("Tournois en tendance"),
        "username": MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
        "verificationCodeSent": m3,
        "verify": MessageLookupByLibrary.simpleMessage("Vérifier"),
        "viewAll": MessageLookupByLibrary.simpleMessage("Afficher tout"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bienvenue sur UrEsport"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("Vous n\'êtes pas connecté")
      };
}
