import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../provider/NotificationProvider.dart';

class AddFriendPage extends StatefulWidget {
  final int userId;
  final String currentUser;

  const AddFriendPage({super.key, required this.userId, required this.currentUser});

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> allUsers = [];
  List<dynamic> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  void fetchAllUsers() async {
    final response = await http.get(Uri.parse('${dotenv.env['API_ENDPOINT']}/users'));
    if (response.statusCode == 200) {
      setState(() {
        allUsers = jsonDecode(response.body);
        filteredUsers = List.from(allUsers);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredUsers = allUsers.where((user) => user['firstname']?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
      } else {
        filteredUsers = List.from(allUsers);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterUsers,
              decoration: InputDecoration(
                labelText: 'Search User',
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    filterUsers('');
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return ListTile(
                  title: Text(user['firstname'] ?? 'Unknown'),
                  onTap: () async {
                    final friendId = user['id'];
                    final currentUser = widget.currentUser;
                    final response = await http.post(Uri.parse('${dotenv.env['API_ENDPOINT']}/users/${widget.userId}/friends/$friendId'));
                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ami ajouté avec succes')));
                      // Envoie une notification
                      Provider.of<NotificationProvider>(context, listen: false)
                          .addNotification('$currentUser vous à ajouté en ami: ${user['firstname']}');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur lors de l\'ajout de l\'ami ou ami déjà ajouté')));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
