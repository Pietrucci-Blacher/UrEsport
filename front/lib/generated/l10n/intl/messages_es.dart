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

  static String m0(date) => "Fin: ${date}";

  static String m1(error) => "Error al seguir el juego: ${error}";

  static String m2(error) => "Error: ${error}";

  static String m3(error) => "Error al dejar de seguir el juego: ${error}";

  static String m4(count) => "Filtros (${count})";

  static String m5(count) => "+${count} más";

  static String m6(username) => "¡Bienvenido a tu perfil, ${username}!";

  static String m7(date) => "Inicio: ${date}";

  static String m8(email) =>
      "Se ha enviado un código de verificación a ${email}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "actions": MessageLookupByLibrary.simpleMessage("Acciones"),
        "activeTournaments":
            MessageLookupByLibrary.simpleMessage("Torneos activos"),
        "activeUsers": MessageLookupByLibrary.simpleMessage("Usuarios activos"),
        "addedToGameList":
            MessageLookupByLibrary.simpleMessage("Juego añadido a tu lista"),
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
        "confirmDeleteGame": MessageLookupByLibrary.simpleMessage(
            "¿Estás seguro de que quieres eliminar este juego?"),
        "dangerZone": MessageLookupByLibrary.simpleMessage("Zona de peligro"),
        "dashboard": MessageLookupByLibrary.simpleMessage("Panel de control"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Eliminar cuenta"),
        "deleteGame": MessageLookupByLibrary.simpleMessage("Eliminar juego"),
        "deleteGameButton":
            MessageLookupByLibrary.simpleMessage("Eliminar el juego"),
        "editProfile": MessageLookupByLibrary.simpleMessage("Editar perfil"),
        "email": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
        "end": m0,
        "errorFollowingGame": m1,
        "errorLoading":
            MessageLookupByLibrary.simpleMessage("Error al cargar los datos"),
        "errorLoadingTournaments": m2,
        "errorUnfollowingGame": m3,
        "filterAndSort":
            MessageLookupByLibrary.simpleMessage("Filtrar y ordenar"),
        "filterByTags":
            MessageLookupByLibrary.simpleMessage("FILTRAR POR ETIQUETAS"),
        "filters": m4,
        "firstName": MessageLookupByLibrary.simpleMessage("Nombre"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("¿Olvidaste tu contraseña?"),
        "gameButton":
            MessageLookupByLibrary.simpleMessage("Ver todos los juegos"),
        "gameDescription":
            MessageLookupByLibrary.simpleMessage("Descripción del Juego"),
        "gameDetailPageTitle":
            MessageLookupByLibrary.simpleMessage("Detalles del Juego"),
        "gameScreenTitle": MessageLookupByLibrary.simpleMessage("Juegos"),
        "gameScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de juegos!"),
        "games": MessageLookupByLibrary.simpleMessage("Juegos"),
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
        "latestMessage": MessageLookupByLibrary.simpleMessage("Último mensaje"),
        "listAllTournaments":
            MessageLookupByLibrary.simpleMessage("Lista de torneos"),
        "listMyTeamsJoined":
            MessageLookupByLibrary.simpleMessage("Mis equipos"),
        "listMyTournaments":
            MessageLookupByLibrary.simpleMessage("Mis torneos"),
        "logIn": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
        "logs": MessageLookupByLibrary.simpleMessage("Registros"),
        "modifyGameButton":
            MessageLookupByLibrary.simpleMessage("Modificar el juego"),
        "moreTagsCount": m5,
        "mustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Debes estar conectado para ver tus torneos"),
        "noGamesAvailable":
            MessageLookupByLibrary.simpleMessage("No hay juegos disponibles."),
        "noLikeToDelete": MessageLookupByLibrary.simpleMessage(
            "No hay me gusta para eliminar"),
        "noTournamentsForGame": MessageLookupByLibrary.simpleMessage(
            "No hay torneos para este juego"),
        "noTournamentsFound":
            MessageLookupByLibrary.simpleMessage("No se encontraron torneos"),
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
        "profileScreenWelcome": m6,
        "register": MessageLookupByLibrary.simpleMessage("Registrarse"),
        "removedFromGameList":
            MessageLookupByLibrary.simpleMessage("Juego eliminado de tu lista"),
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
        "start": m7,
        "tags": MessageLookupByLibrary.simpleMessage("Etiquetas"),
        "totalGames": MessageLookupByLibrary.simpleMessage("Juegos totales"),
        "tournamentScreenTitle":
            MessageLookupByLibrary.simpleMessage("Torneos"),
        "tournamentScreenWelcome": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a la pantalla de torneos!"),
        "tournaments": MessageLookupByLibrary.simpleMessage("Torneos"),
        "trendingTournamentsTitle":
            MessageLookupByLibrary.simpleMessage("Torneos en tendencia"),
        "unknownPage":
            MessageLookupByLibrary.simpleMessage("Página desconocida"),
        "username": MessageLookupByLibrary.simpleMessage("Nombre de usuario"),
        "users": MessageLookupByLibrary.simpleMessage("Usuarios"),
        "verificationCodeSent": m8,
        "verify": MessageLookupByLibrary.simpleMessage("Verificar"),
        "viewAll": MessageLookupByLibrary.simpleMessage("Ver todo"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Bienvenido a UrEsport"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("No has iniciado sesión"),
        "youMustBeLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Debes estar conectado para seguir este juego")
      };
}
