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

  static String m0(username) => "¡Bienvenido a tu perfil, ${username}!";

  static String m1(email) =>
      "Se ha enviado un código de verificación a ${email}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle": MessageLookupByLibrary.simpleMessage("UrEsport"),
        "email": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
        "firstName": MessageLookupByLibrary.simpleMessage("Nombre"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("¿Olvidaste tu contraseña?"),
        "gameScreenTitle": MessageLookupByLibrary.simpleMessage("Juegos"),
        "gameScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de juegos!"),
        "homeScreenTitle": MessageLookupByLibrary.simpleMessage("Inicio"),
        "homeScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de inicio!"),
        "lastName": MessageLookupByLibrary.simpleMessage("Apellido"),
        "logIn": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "notificationScreenTitle":
            MessageLookupByLibrary.simpleMessage("Notificaciones"),
        "notificationScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de notificaciones!"),
        "orLoginWith":
            MessageLookupByLibrary.simpleMessage("O iniciar sesión con"),
        "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
        "passwordResetEmailSent": MessageLookupByLibrary.simpleMessage(
            "Correo electrónico de restablecimiento de contraseña enviado"),
        "passwordResetSuccessful": MessageLookupByLibrary.simpleMessage(
            "Restablecimiento de contraseña exitoso"),
        "profileScreenTitle": MessageLookupByLibrary.simpleMessage("Perfil"),
        "profileScreenWelcome": m0,
        "register": MessageLookupByLibrary.simpleMessage("Registrarse"),
        "resendCode":
            MessageLookupByLibrary.simpleMessage("Reenviar el código"),
        "resetPassword":
            MessageLookupByLibrary.simpleMessage("Restablecer la contraseña"),
        "sendResetEmail": MessageLookupByLibrary.simpleMessage(
            "Enviar correo de restablecimiento"),
        "tournamentScreenTitle":
            MessageLookupByLibrary.simpleMessage("Torneos"),
        "tournamentScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de torneos!"),
        "username": MessageLookupByLibrary.simpleMessage("Nombre de usuario"),
        "verificationCodeSent": m1,
        "verify": MessageLookupByLibrary.simpleMessage("Verificar"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bienvenido a UrEsport"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("No has iniciado sesión")
      };
}
