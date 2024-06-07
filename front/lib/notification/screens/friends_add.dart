import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uresport/services/notification_service.dart'; // Assurez-vous que le chemin est correct

class AddFriendPage extends StatefulWidget {
  final int userId;
  final String currentUser;

  const AddFriendPage({Key? key, required this.userId, required this.currentUser}) : super(key: key);

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
        title: Text('Add Friend'),
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
                  icon: Icon(Icons.clear),
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Friend added successfully')));
                      // Envoie une notification
                      Provider.of<NotificationService>(context, listen: false)
                          .addNotification('$currentUser vous à ajouté en ami: ${user['firstname']}', ''); // Ajoutez l'URL de l'image si nécessaire
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add friend')));
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
