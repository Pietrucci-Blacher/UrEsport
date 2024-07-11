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

  static String m0(count) => "Filtros (${count})";

  static String m1(count) => "+${count} más";

  static String m2(username) => "¡Bienvenido a tu perfil, ${username}!";

  static String m3(email) =>
      "Se ha enviado un código de verificación a ${email}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "alphabeticalAZ":
            MessageLookupByLibrary.simpleMessage("Alfabético (A-Z)"),
        "alphabeticalZA":
            MessageLookupByLibrary.simpleMessage("Alfabético (Z-A)"),
        "anErrorOccurred":
            MessageLookupByLibrary.simpleMessage("¡Se produjo un error!"),
        "appTitle": MessageLookupByLibrary.simpleMessage("UrEsport"),
        "applyFilters": MessageLookupByLibrary.simpleMessage("Aplicar filtros"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "cancelEditing":
            MessageLookupByLibrary.simpleMessage("Cancelar edición"),
        "closeButton": MessageLookupByLibrary.simpleMessage("Cerrar"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
        "dangerZone": MessageLookupByLibrary.simpleMessage("Zona de peligro"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Eliminar cuenta"),
        "deleteGameButton":
            MessageLookupByLibrary.simpleMessage("Eliminar el juego"),
        "editProfile": MessageLookupByLibrary.simpleMessage("Editar perfil"),
        "email": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
        "filterAndSort":
            MessageLookupByLibrary.simpleMessage("Filtrar y ordenar"),
        "filterByTags":
            MessageLookupByLibrary.simpleMessage("FILTRAR POR ETIQUETAS"),
        "filters": m0,
        "firstName": MessageLookupByLibrary.simpleMessage("Nombre"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("¿Olvidaste tu contraseña?"),
        "gameButton":
            MessageLookupByLibrary.simpleMessage("Ver todos los juegos"),
        "gameScreenTitle": MessageLookupByLibrary.simpleMessage("Juegos"),
        "gameScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de juegos!"),
        "homeScreenTitle": MessageLookupByLibrary.simpleMessage("Inicio"),
        "homeScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de inicio!"),
        "inviteButton": MessageLookupByLibrary.simpleMessage("Invitar"),
        "inviteError":
            MessageLookupByLibrary.simpleMessage("Error de invitación"),
        "inviteSuccess":
            MessageLookupByLibrary.simpleMessage("Ha sido invitado"),
        "joinButton": MessageLookupByLibrary.simpleMessage("Unirse"),
        "lastName": MessageLookupByLibrary.simpleMessage("Apellido"),
        "logIn": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
        "modifyGameButton":
            MessageLookupByLibrary.simpleMessage("Modificar el juego"),
        "moreTagsCount": m1,
        "noGamesAvailable":
            MessageLookupByLibrary.simpleMessage("No hay juegos disponibles."),
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
        "popularGamesTitle":
            MessageLookupByLibrary.simpleMessage("Juegos populares"),
        "profileScreenTitle": MessageLookupByLibrary.simpleMessage("Perfil"),
        "profileScreenWelcome": m2,
        "register": MessageLookupByLibrary.simpleMessage("Registrarse"),
        "resendCode":
            MessageLookupByLibrary.simpleMessage("Reenviar el código"),
        "reset": MessageLookupByLibrary.simpleMessage("Restablecer"),
        "resetPassword":
            MessageLookupByLibrary.simpleMessage("Restablecer la contraseña"),
        "save": MessageLookupByLibrary.simpleMessage("Guardar"),
        "searchTags": MessageLookupByLibrary.simpleMessage("Buscar etiquetas"),
        "sendResetEmail": MessageLookupByLibrary.simpleMessage(
            "Enviar correo de restablecimiento"),
        "sort": MessageLookupByLibrary.simpleMessage("ORDENAR"),
        "tournamentScreenTitle":
            MessageLookupByLibrary.simpleMessage("Torneos"),
        "tournamentScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de torneos!"),
        "trendingTournamentsTitle":
            MessageLookupByLibrary.simpleMessage("Torneos en tendencia"),
        "username": MessageLookupByLibrary.simpleMessage("Nombre de usuario"),
        "verificationCodeSent": m3,
        "verify": MessageLookupByLibrary.simpleMessage("Verificar"),
        "viewAll": MessageLookupByLibrary.simpleMessage("Ver todo"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bienvenido a UrEsport"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("No has iniciado sesión")
      };
}
