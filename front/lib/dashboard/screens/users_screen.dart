import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/core/services/auth_service.dart'; // Assurez-vous d'importer le service

import 'edit_user.dart';

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
  final AuthService _authService = AuthService(Dio()); // Instancier le service avec Dio

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search Users',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex:
        ['username', 'firstname', 'lastname', 'email'].indexOf(_sortColumn),
        sortAscending: _sortAscending,
        columns: [
          DataColumn(
            label: const Text('Username'),
            onSort: (columnIndex, _) => _onSort('username'),
          ),
          DataColumn(
            label: const Text('First Name'),
            onSort: (columnIndex, _) => _onSort('firstname'),
          ),
          DataColumn(
            label: const Text('Last Name'),
            onSort: (columnIndex, _) => _onSort('lastname'),
          ),
          DataColumn(
            label: const Text('Email'),
            onSort: (columnIndex, _) => _onSort('email'),
          ),
          const DataColumn(label: Text('Roles')),
          const DataColumn(label: Text('Actions')),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ID: ${user.id}'),
            Text('Username: ${user.username}'),
            Text('Name: ${user.firstname} ${user.lastname}'),
            Text('Email: ${user.email}'),
            Text('Roles: ${user.roles.join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _editUser(User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditUserPage(user: user),
      ),
    ).then((result) {
      if (result == true) {
        _fetchUsers(); // Refresh the list after editing a user
      }
    });
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.username}?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () async {
              try {
                await _authService.deleteAccount(user.id);
                Navigator.of(context).pop();
                _fetchUsers(); // Refresh the list after deleting a user
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete user: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
