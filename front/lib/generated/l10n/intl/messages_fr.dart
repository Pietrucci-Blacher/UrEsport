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

  static String m0(username) => "Bienvenue sur votre profil, ${username} !";

  static String m1(email) => "Un code de vérification a été envoyé à ${email}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle": MessageLookupByLibrary.simpleMessage("UrEsport"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "firstName": MessageLookupByLibrary.simpleMessage("Prénom"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Mot de passe oublié ?"),
        "gameScreenTitle": MessageLookupByLibrary.simpleMessage("Jeux"),
        "gameScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran des jeux !"),
        "homeScreenTitle": MessageLookupByLibrary.simpleMessage("Accueil"),
        "homeScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran d\'accueil !"),
        "lastName": MessageLookupByLibrary.simpleMessage("Nom"),
        "logIn": MessageLookupByLibrary.simpleMessage("Connexion"),
        "login": MessageLookupByLibrary.simpleMessage("Connexion"),
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
        "profileScreenTitle": MessageLookupByLibrary.simpleMessage("Profil"),
        "profileScreenWelcome": m0,
        "register": MessageLookupByLibrary.simpleMessage("Inscription"),
        "resendCode":
            MessageLookupByLibrary.simpleMessage("Ré-envoyer le code"),
        "resetPassword": MessageLookupByLibrary.simpleMessage(
            "Réinitialiser le mot de passe"),
        "sendResetEmail": MessageLookupByLibrary.simpleMessage(
            "Envoyer l\'email de réinitialisation"),
        "tournamentScreenTitle":
            MessageLookupByLibrary.simpleMessage("Tournois"),
        "tournamentScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "Bienvenue à l\'écran des tournois !"),
        "username": MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
        "verificationCodeSent": m1,
        "verify": MessageLookupByLibrary.simpleMessage("Vérifier"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bienvenue sur UrEsport"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("Vous n\'êtes pas connecté")
      };
}
