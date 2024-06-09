import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import 'invite_button.dart';
import 'join_button.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final PagingController<int, User> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      const int pageSize = 10; // Nombre d'utilisateurs par page
      final List<User> newItems = await UserService.fetchUsers(page: pageKey + 1, limit: pageSize);

      if (newItems.isEmpty) {
        _pagingController.appendLastPage([]);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: PagedListView<int, User>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<User>(
          itemBuilder: (context, user, index) {
            return ListTile(
              title: Text(user.username),
              subtitle: Row(
                children: [
                  InviteButton(
                    username: user.username,
                  ),
                  JoinButton(
                    username: user.username,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
