import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/cache_service.dart';

import 'package:uresport/l10n/app_localizations.dart';

class EditUserPage extends StatefulWidget {
  final User? user;

  const EditUserPage({super.key, this.user});

  @override
  EditUserPageState createState() => EditUserPageState();
}

class EditUserPageState extends State<EditUserPage> {
  late TextEditingController usernameController;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController emailController;
  late TextEditingController rolesController;
  late TextEditingController profileImageUrlController;

  final Dio _dio = Dio();
  final CacheService _cacheService = CacheService.instance;

  // Variables pour stocker les valeurs initiales
  late String initialUsername;
  late String initialFirstname;
  late String initialLastname;
  late String initialEmail;
  late String initialRoles;
  late String initialProfileImageUrl;

  @override
  void initState() {
    super.initState();
    usernameController =
        TextEditingController(text: widget.user?.username ?? '');
    firstnameController =
        TextEditingController(text: widget.user?.firstname ?? '');
    lastnameController =
        TextEditingController(text: widget.user?.lastname ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
    rolesController =
        TextEditingController(text: widget.user?.roles.join(', ') ?? '');
    profileImageUrlController =
        TextEditingController(text: widget.user?.profileImageUrl ?? '');

    // Initialiser les valeurs initiales
    initialUsername = widget.user?.username ?? '';
    initialFirstname = widget.user?.firstname ?? '';
    initialLastname = widget.user?.lastname ?? '';
    initialEmail = widget.user?.email ?? '';
    initialRoles = widget.user?.roles.join(', ') ?? '';
    initialProfileImageUrl = widget.user?.profileImageUrl ?? '';
  }

  @override
  void dispose() {
    usernameController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    rolesController.dispose();
    profileImageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    AppLocalizations l = AppLocalizations.of(context);
    if (widget.user == null) {
      // Logic for adding a new user
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
             content: Text(
                 l.addingNewUserFunctionalityNotImplemented
             )
         ),
      );
    } else {
      // Comparer les valeurs initiales avec les valeurs actuelles
      final Map<String, dynamic> updatedFields = {};

      if (usernameController.text != initialUsername) {
        updatedFields['username'] = usernameController.text;
      }
      if (firstnameController.text != initialFirstname) {
        updatedFields['firstname'] = firstnameController.text;
      }
      if (lastnameController.text != initialLastname) {
        updatedFields['lastname'] = lastnameController.text;
      }
      if (emailController.text != initialEmail) {
        updatedFields['email'] = emailController.text;
      }
      // Vérifier s'il y a des champs modifiés à envoyer
      if (updatedFields.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.noChangesMade)),
        );
        return;
      }

      // Log the data being sent to the backend
      debugPrint('Sending data to backend: $updatedFields');

      try {
        final token = await _cacheService.getString('token');
        if (token == null) throw Exception('No token found');
        final response = await _dio.patch(
          '${dotenv.env['API_ENDPOINT']}/users/${widget.user!.id}',
          data: updatedFields,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
        );

        // Log the response from the backend
        debugPrint(
            'Response from backend: ${response.statusCode} - ${response.data}');

        if (response.statusCode == 200) {
          // Successfully updated the user
          if (!mounted) return;
          Navigator.of(context).pop(true); // Return true to indicate success
        } else {
          // Handle error
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('${l.failedToUpdateUser}: ${response.statusMessage}')),
          );
        }
      } catch (e) {
        // Log the error
        debugPrint('Error updating user: $e');

        // Handle error
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l.failedToUpdateUser}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? l.addUser : l.editUser),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: l.username),
              ),
              TextField(
                controller: firstnameController,
                decoration:  InputDecoration(labelText: l.firstName),
              ),
              TextField(
                controller: lastnameController,
                decoration:  InputDecoration(labelText: l.lastName),
              ),
              TextField(
                controller: emailController,
                decoration:  InputDecoration(labelText: l.email),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child:  Text(l.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
