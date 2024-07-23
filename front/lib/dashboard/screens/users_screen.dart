import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/core/services/auth_service.dart';

import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/dashboard/screens/edit_user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  UsersPageState createState() => UsersPageState();
}

class UsersPageState extends State<UsersPage> {
  String _searchQuery = '';
  String _sortColumn = 'username';
  bool _sortAscending = true;
  final List<String> _selectedRoles = [];
  final AuthService _authService =
      AuthService(Dio()); // Instancier le service avec Dio

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    context.read<DashboardBloc>().add(FetchAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoaded) {
          List<User> filteredUsers = _filterAndSortUsers(state.users);
          return Column(
            children: [
              _buildSearchBar(),
              _buildFilterChips(),
              Expanded(
                child: _buildUserTable(filteredUsers),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildSearchBar() {
    AppLocalizations l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: l.searchUsers,
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    List<String> allRoles = ['admin', 'user'];
    return Wrap(
      spacing: 8.0,
      children: allRoles.map((role) {
        return FilterChip(
          label: Text(role),
          selected: _selectedRoles.contains(role),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedRoles.add(role);
              } else {
                _selectedRoles.remove(role);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildUserTable(List<User> users) {
    AppLocalizations l = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex:
            ['username', 'firstname', 'lastname', 'email'].indexOf(_sortColumn),
        sortAscending: _sortAscending,
        columns: [
          DataColumn(
            label: Text(l.username),
            onSort: (columnIndex, _) => _onSort('username'),
          ),
          DataColumn(
            label: Text(l.firstName),
            onSort: (columnIndex, _) => _onSort('firstname'),
          ),
          DataColumn(
            label: Text(l.lastName),
            onSort: (columnIndex, _) => _onSort('lastname'),
          ),
          DataColumn(
            label: Text(l.email),
            onSort: (columnIndex, _) => _onSort('email'),
          ),
          DataColumn(label: Text(l.rolesText)),
          DataColumn(label: Text(l.actionsText)),
        ],
        rows: users.map((user) {
          return DataRow(
            cells: [
              DataCell(Text(user.username)),
              DataCell(Text(user.firstname)),
              DataCell(Text(user.lastname)),
              DataCell(Text(user.email)),
              DataCell(Text(user.roles.join(', '))),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () => _viewUser(user),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editUser(user),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteUser(user),
                  ),
                ],
              )),
            ],
          );
        }).toList(),
      ),
    );
  }

  List<User> _filterAndSortUsers(List<User> users) {
    List<User> filteredUsers = users.where((user) {
      return (user.username
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              user.firstname
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              user.lastname
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(_searchQuery.toLowerCase())) &&
          (_selectedRoles.isEmpty ||
              _selectedRoles.any((role) => user.roles.contains(role)));
    }).toList();

    filteredUsers.sort((a, b) {
      var aValue = _getUserValue(a, _sortColumn);
      var bValue = _getUserValue(b, _sortColumn);
      return _sortAscending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    return filteredUsers;
  }

  dynamic _getUserValue(User user, String column) {
    switch (column) {
      case 'username':
        return user.username;
      case 'firstname':
        return user.firstname;
      case 'lastname':
        return user.lastname;
      case 'email':
        return user.email;
      default:
        return '';
    }
  }

  void _onSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
    });
  }

  void _viewUser(User user) {
    AppLocalizations l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${l.idText}: ${user.id}'),
            Text('${l.username}: ${user.username}'),
            Text('${l.name}: ${user.firstname} ${user.lastname}'),
            Text('${l.email}: ${user.email}'),
            Text('${l.rolesText}: ${user.roles.join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            child: Text(l.closeButton),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _editUser(User user) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => EditUserPage(user: user),
      ),
    )
        .then((result) {
      if (result == true) {
        _fetchUsers(); // Refresh the list after editing a user
      }
    });
  }

  void _deleteUser(User user) {
    AppLocalizations l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteUserTitle),
        content: Text('${l.confirmDeleteUser}: ${user.username}?'),
        actions: [
          TextButton(
            child: Text(l.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(l.delete),
            onPressed: () async {
              try {
                await _authService.deleteAccount(user.id);
                if (!context.mounted) return;
                Navigator.of(context).pop();
                _fetchUsers(); // Refresh the list after deleting a user
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l.failedToDeleteUser}: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
