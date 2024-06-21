import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/auth/screens/auth_screen.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:uresport/shared/utils/image_util.dart';
import 'package:uresport/shared/locale_switcher.dart';
import 'package:uresport/cubit/locale_cubit.dart';

class ProfileScreen extends StatefulWidget {
  final IAuthService authService;

  const ProfileScreen({super.key, required this.authService});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  bool _isEditing = false;
  final Map<String, dynamic> _updatedFields = {};
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  User? _user;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => AuthBloc(widget.authService)..add(AuthCheckRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).profileScreenTitle),
          actions: [
            LocaleSwitcher(
              onLocaleChanged: (locale) {
                context.read<LocaleCubit>().setLocale(locale);
              },
            ),
          ],
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is PasswordResetEmailSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context).passwordResetEmailSent)),
              );
            } else if (state is PasswordResetConfirmed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context).passwordResetSuccessful)),
              );
            } else if (state is AuthAuthenticated) {
              _initializeControllers(state.user);
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AuthAuthenticated) {
                if (_user == null) {
                  return FutureBuilder<void>(
                    future: _initializeControllers(state.user),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return _buildProfileScreen(context);
                      }
                    },
                  );
                }
                return _buildProfileScreen(context);
              } else {
                return _buildLoginRegisterButtons(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _initializeControllers(User user) async {
    setState(() {
      _user = user;
      _firstNameController.text = user.firstname;
      _lastNameController.text = user.lastname;
      _usernameController.text = user.username;
      _emailController.text = user.email;
    });
  }

  Widget _buildLoginRegisterButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).youAreNotLoggedIn,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthScreen(
                    authService: widget.authService,
                    showLogin: true,
                    showRegister: !kIsWeb,
                  ),
                ),
              ).then((_) {
                if (mounted) {
                  context.read<AuthBloc>().add(AuthCheckRequested());
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(AppLocalizations.of(context).logIn),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileScreen(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileAvatarWidget(
            user: _user,
            onImageUpdated: (imageUrl) {
              setState(() {
                _user = _user?.copyWith(profileImageUrl: imageUrl);
              });
              context.read<AuthBloc>().add(ProfileImageUpdated(imageUrl));
            },
          ),
          const SizedBox(height: 20),
          Text(
            '${_user?.firstname ?? ''} ${_user?.lastname ?? ''}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            _user?.username ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Divider(height: 40),
          _buildEditableFields(context),
          const Divider(height: 40),
          _buildDangerZone(context, _user?.id ?? 0),
        ],
      ),
    );
  }

  Widget _buildEditableFields(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (!_isEditing && _user != null) {
                    _initializeControllers(_user!);
                  }
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildEditableField(_firstNameController, 'First Name', 'firstname'),
        const SizedBox(height: 10),
        _buildEditableField(_lastNameController, 'Last Name', 'lastname'),
        const SizedBox(height: 10),
        _buildEditableField(_usernameController, 'Username', 'username'),
        const SizedBox(height: 10),
        _buildEditableField(_emailController, 'Email', 'email'),
        const SizedBox(height: 20),
        if (_isEditing)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _updatedFields.isNotEmpty ? () => _saveProfile() : null,
                child: const Text('Save'),
              ),
              ElevatedButton(
                onPressed: () => _cancelEditing(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildEditableField(TextEditingController controller, String label, String field) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      enabled: _isEditing,
      onChanged: (value) {
        setState(() {
          if (value != (_user?.toJson()[field] ?? '')) {
            _updatedFields[field] = value;
          } else {
            _updatedFields.remove(field);
          }
        });
      },
    );
  }

  Future<void> _saveProfile() async {
    if (_user == null) return;
    final userId = _user!.id;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final authBloc = context.read<AuthBloc>();
    try {
      await authBloc.authService.updateUserInfo(userId, _updatedFields);
      authBloc.add(UserInfoUpdated(userId, _updatedFields));
      setState(() {
        _isEditing = false;
        _updatedFields.clear();
      });
    } catch (e) {
      debugPrint('Error saving profile: $e');
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }
  }

  void _cancelEditing(BuildContext context) {
    setState(() {
      _isEditing = false;
      _updatedFields.clear();
      if (_user != null) {
        _initializeControllers(_user!);
      }
    });
  }

  Widget _buildDangerZone(BuildContext context, int userId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Danger Zone',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 10),
        _buildDangerZoneTile(
          context,
          icon: Icons.logout,
          label: 'Logout',
          onTap: () => _showConfirmationDialog(
            context,
            title: 'Logout',
            content: 'Are you sure you want to logout?',
            confirmAction: () => context.read<AuthBloc>().add(AuthLoggedOut()),
          ),
        ),
        _buildDangerZoneTile(
          context,
          icon: Icons.delete,
          label: 'Delete Account',
          onTap: () => _showConfirmationDialog(
            context,
            title: 'Delete Account',
            content: 'Are you sure you want to delete your account? This action cannot be undone.',
            confirmAction: () async {
              final authBloc = context.read<AuthBloc>();
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                await authBloc.authService.deleteAccount(userId);
                authBloc.add(AuthLoggedOut());
              } catch (e) {
                debugPrint('Error deleting account: $e');
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Error deleting account: $e')),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDangerZoneTile(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(
        label,
        style: const TextStyle(color: Colors.red),
      ),
      onTap: onTap,
    );
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, {
        required String title,
        required String content,
        required VoidCallback confirmAction,
      }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                confirmAction();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ProfileAvatarWidget extends StatefulWidget {
  final User? user;
  final ValueChanged<String> onImageUpdated;

  const ProfileAvatarWidget({
    super.key,
    required this.user,
    required this.onImageUpdated,
  });

  @override
  ProfileAvatarWidgetState createState() => ProfileAvatarWidgetState();
}

class ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _profileImageUrl;
  bool _isUpdatingImage = false;

  @override
  void initState() {
    super.initState();
    _profileImageUrl = widget.user?.profileImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePickerOptions(context),
      child: Stack(
        children: <Widget>[
          ClipOval(
            child: _isUpdatingImage
                ? const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: CircularProgressIndicator(),
            )
                : CachedImageWidget(
              url: _profileImageUrl ?? '',
              size: 100,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePickerOptions(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _updateProfileImage(scaffoldMessenger);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _updateProfileImage(ScaffoldMessengerState scaffoldMessenger) async {
    setState(() {
      _isUpdatingImage = true;
    });

    final authBloc = context.read<AuthBloc>();
    final userId = widget.user!.id;
    try {
      final imageUrl = await authBloc.authService.uploadProfileImage(userId, _imageFile!);
      setState(() {
        _profileImageUrl = '$imageUrl?v=${DateTime.now().millisecondsSinceEpoch}';
        _isUpdatingImage = false;
      });
      widget.onImageUpdated(_profileImageUrl!);
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      setState(() {
        _isUpdatingImage = false;
      });
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error uploading profile image: $e')),
      );
    }
  }
}
