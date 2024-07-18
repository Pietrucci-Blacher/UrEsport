import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/cache_service.dart';

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
  late TextEditingController passwordController;

  final Dio _dio = Dio();
  final CacheService _cacheService = CacheService.instance;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user?.username ?? '');
    firstnameController = TextEditingController(text: widget.user?.firstname ?? '');
    lastnameController = TextEditingController(text: widget.user?.lastname ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
    rolesController = TextEditingController(text: widget.user?.roles.join(', ') ?? '');
    profileImageUrlController = TextEditingController(text: widget.user?.profileImageUrl ?? '');
    passwordController = TextEditingController(); // Initialiser un champ mot de passe vide
  }

  @override
  void dispose() {
    usernameController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    rolesController.dispose();
    profileImageUrlController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (widget.user == null) {
      // Logic for adding a new user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adding new user functionality not implemented')),
      );
    } else {
      // Edit existing user
      final updatedUser = widget.user!.copyWith(
        username: usernameController.text,
        firstname: firstnameController.text,
        lastname: lastnameController.text,
        email: emailController.text,
        password: passwordController.text.isNotEmpty ? passwordController.text : null, // Ajout du champ mot de passe
      );

      // Log the data being sent to the backend
      final updatedUserJson = updatedUser.toUpdateJson();
      print('Sending data to backend: $updatedUserJson');

      try {
        final token = await _cacheService.getString('token');
        if (token == null) throw Exception('No token found');
        final response = await _dio.patch(
          '${dotenv.env['API_ENDPOINT']}/users/${updatedUser.id}',
          data: updatedUserJson,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
        );

        // Log the response from the backend
        print('Response from backend: ${response.statusCode} - ${response.data}');

        if (response.statusCode == 200) {
          // Successfully updated the user
          if (!mounted) return;
          Navigator.of(context).pop(true); // Return true to indicate success
        } else {
          // Handle error
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update user: ${response.statusMessage}')),
          );
        }
      } catch (e) {
        // Log the error
        print('Error updating user: $e');

        // Handle error
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: firstnameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastnameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
