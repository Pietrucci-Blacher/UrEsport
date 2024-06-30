import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:uresport/shared/provider/NotificationProvider.dart';
import 'package:dio/dio.dart';
import 'package:uresport/core/services/friends_services.dart';
import 'package:uresport/widgets/custom_toast.dart';

class AddFriendPage extends StatefulWidget {
  final int userId;
  final String currentUser;

  const AddFriendPage(
      {super.key, required this.userId, required this.currentUser});

  @override
  AddFriendPageState createState() => AddFriendPageState();
}

class AddFriendPageState extends State<AddFriendPage> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> allUsers = [];
  List<dynamic> filteredUsers = [];

  final FriendService friendService = FriendService(Dio(BaseOptions(
    baseUrl: dotenv.env['API_ENDPOINT']!,
  )));

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  void fetchAllUsers() async {
    try {
      final response = await Dio().get('${dotenv.env['API_ENDPOINT']}/users');
      setState(() {
        allUsers = response.data;
        filteredUsers = List.from(allUsers);
      });
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredUsers = allUsers
            .where((user) =>
                user['firstname']
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false)
            .toList();
      } else {
        filteredUsers = List.from(allUsers);
      }
    });
  }

  void showNotificationToast(BuildContext context, String message,
      {Color? backgroundColor, Color? textColor}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomToast(
        message: message,
        backgroundColor: backgroundColor ?? Colors.green,
        textColor: textColor ?? Colors.white,
        onClose: () {
          overlayEntry.remove();
        },
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
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
                    try {
                      friendService.addFriend(
                        widget.userId,
                        friendId,
                      );
                      showNotificationToast(context, 'Ami ajouté avec succès');
                      Provider.of<NotificationProvider>(context, listen: false)
                          .addNotification(
                              '$currentUser vous a ajouté en ami: ${user['firstname']}');
                    } catch (e) {
                      String errorMessage;
                      if (e is DioException) {
                        if (e.message == 'Ami déjà ajouté') {
                          errorMessage = 'Ami déjà ajouté';
                        } else {
                          errorMessage = 'Erreur lors de l\'ajout de l\'ami';
                        }
                      } else {
                        errorMessage = 'Erreur lors de l\'ajout de l\'ami';
                      }
                      showNotificationToast(
                        context,
                        errorMessage,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
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
