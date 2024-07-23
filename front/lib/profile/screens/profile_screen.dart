import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/core/models/like.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/like_service.dart';
import 'package:uresport/cubit/locale_cubit.dart';
import 'package:uresport/game/screens/game_detail.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/main_screen.dart';
import 'package:uresport/shared/locale_switcher.dart';
import 'package:uresport/shared/navigation/bottom_navigation.dart';
import 'package:uresport/shared/utils/image_util.dart' as image_util;

class ProfileScreen extends StatefulWidget {
  final IAuthService authService;
  final ValueNotifier<String?> profileImageNotifier;

  const ProfileScreen({
    super.key,
    required this.authService,
    required this.profileImageNotifier,
  });

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
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
    AppLocalizations l = AppLocalizations.of(context);
    super.build(context);
    return BlocProvider(
      create: (context) =>
          AuthBloc(widget.authService)..add(AuthCheckRequested()),
      child: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: Text(l.profileScreenTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              LocaleSwitcher(
                onLocaleChanged: (locale) {
                  context.read<LocaleCubit>().setLocale(locale);
                },
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: l.profileTab),
                Tab(text: l.likedGamesTab),
              ],
            ),
          ),
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              } else if (state is PasswordResetEmailSent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.passwordResetEmailSent)),
                );
              } else if (state is PasswordResetConfirmed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.passwordResetSuccessful)),
                );
              } else if (state is AuthAuthenticated) {
                _initializeControllers(state.user);
              } else if (state is AuthUnauthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          MainScreen(authService: widget.authService),
                    ),
                    (Route<dynamic> route) => false,
                  );
                });
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return _buildTabBarView(context);
                        }
                      },
                    );
                  }
                  return _buildTabBarView(context);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initializeControllers(User user) async {
    _performIfMounted(() {
      _user = user;
      _firstNameController.text = user.firstname;
      _lastNameController.text = user.lastname;
      _usernameController.text = user.username;
      _emailController.text = user.email;
      widget.profileImageNotifier.value = user.profileImageUrl;
    });
  }

  void _performIfMounted(void Function() action) {
    if (mounted) {
      setState(action);
    }
  }

  Widget _buildTabBarView(BuildContext context) {
    return TabBarView(
      children: [
        _buildProfileScreen(context),
        _buildLikedGamesScreen(context),
      ],
    );
  }

  Widget _buildProfileScreen(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileAvatarSection(
            profileImageNotifier: widget.profileImageNotifier,
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
          if (_user != null)
            EditableFieldsSection(
              user: _user!,
              onSave: _saveProfile,
            ),
          const Divider(height: 40),
          _buildDangerZone(context, _user?.id ?? 0),
        ],
      ),
    );
  }

  Widget _buildLikedGamesScreen(BuildContext context) {
    return LikedGamesList(userId: _user?.id);
  }

  Future<void> _saveProfile(Map<String, dynamic> updatedFields) async {
    final authBloc = context.read<AuthBloc>();

    try {
      await authBloc.authService.updateUserInfo(_user!.id, updatedFields);
      _performIfMounted(() {
        _user = _user!.copyWith(
          firstname: updatedFields['firstname'] ?? _user!.firstname,
          lastname: updatedFields['lastname'] ?? _user!.lastname,
          username: updatedFields['username'] ?? _user!.username,
          email: updatedFields['email'] ?? _user!.email,
        );
      });
      authBloc.add(UserFieldUpdated(updatedFields));
      _performIfMounted(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).profileUpdated)),
        );
      });
    } catch (e) {
      debugPrint('Error saving profile: $e');
      _performIfMounted(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context).errorSavingProfile)),
        );
      });
    }
  }

  Widget _buildDangerZone(BuildContext context, int userId) {
    AppLocalizations l = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.dangerZone,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 10),
        _buildDangerZoneTile(
          context,
          icon: Icons.logout,
          label: l.logout,
          onTap: () => _showConfirmationDialog(
            context,
            title: l.logout,
            content: l.logoutConfirmation,
            confirmAction: () {
              context.read<AuthBloc>().add(AuthLoggedOut());
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) =>
                        MainScreen(authService: widget.authService),
                  ),
                  (Route<dynamic> route) => false,
                );
              });
            },
          ),
        ),
        _buildDangerZoneTile(
          context,
          icon: Icons.delete,
          label: l.deleteAccount,
          onTap: () {
            final authBloc = context.read<AuthBloc>();

            _showConfirmationDialog(
              context,
              title: l.deleteAccount,
              content: l.deleteAccountConfirmation,
              confirmAction: () async {
                try {
                  await authBloc.authService.deleteAccount(userId);
                  _performIfMounted(() {
                    authBloc.add(AuthLoggedOut());
                  });
                } catch (e) {
                  debugPrint('Error deleting account: $e');
                  _performIfMounted(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.errorDeletingAccount)),
                    );
                  });
                }
              },
            );
          },
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
              child: Text(AppLocalizations.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).confirm),
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

class ProfileAvatarSection extends StatelessWidget {
  final ValueNotifier<String?> profileImageNotifier;

  const ProfileAvatarSection({
    super.key,
    required this.profileImageNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: profileImageNotifier,
      builder: (context, profileImageUrl, _) {
        return ProfileAvatarWidget(
          profileImageUrl: profileImageUrl,
          onImageUpdated: (imageUrl) {
            profileImageNotifier.value = imageUrl;
            context.read<AuthBloc>().add(ProfileImageUpdated(imageUrl));
          },
        );
      },
    );
  }
}

class ProfileAvatarWidget extends StatefulWidget {
  final String? profileImageUrl;
  final ValueChanged<String> onImageUpdated;

  const ProfileAvatarWidget({
    super.key,
    required this.profileImageUrl,
    required this.onImageUpdated,
  });

  @override
  ProfileAvatarWidgetState createState() => ProfileAvatarWidgetState();
}

class ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  bool _isUpdatingImage = false;
  String? _localProfileImageUrl;

  @override
  void initState() {
    super.initState();
    _localProfileImageUrl = widget.profileImageUrl;
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
                : _localProfileImageUrl != null
                    ? image_util.CachedImageWidget(
                        url: _localProfileImageUrl!,
                        size: 100,
                      )
                    : const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person),
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
    AppLocalizations l = AppLocalizations.of(context);
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(l.photoLibrary),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(l.camera),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(context, ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final localizations = AppLocalizations.of(context);

    try {
      setState(() {
        _isUpdatingImage = true;
      });

      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile == null) {
        debugPrint('No image selected.');
        setState(() {
          _isUpdatingImage = false;
        });
        return;
      }

      final File imageFile = File(pickedFile.path);
      if (!await imageFile.exists()) {
        debugPrint('Selected image file does not exist: ${pickedFile.path}');
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(localizations.errorPickingImage)),
        );
        setState(() {
          _isUpdatingImage = false;
        });
        return;
      }

      if (!mounted) return;

      final user = await _getAuthenticatedUser();
      if (user == null) {
        debugPrint('User is not authenticated');
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(localizations.anErrorOccurred)),
        );
        setState(() {
          _isUpdatingImage = false;
        });
        return;
      }

      await _updateProfileImage(
        imageFile,
        user.id,
        scaffoldMessenger,
        localizations,
        widget.onImageUpdated,
      );
    } catch (e) {
      debugPrint('Error picking image: $e');
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('${localizations.errorPickingImage}: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingImage = false;
        });
      }
    }
  }

  Future<User?> _getAuthenticatedUser() async {
    final authBloc = context.read<AuthBloc>();
    final state = authBloc.state;
    if (state is AuthAuthenticated) {
      return state.user;
    }
    return null;
  }

  Future<void> _updateProfileImage(
    File imageFile,
    int userId,
    ScaffoldMessengerState scaffoldMessenger,
    AppLocalizations localizations,
    ValueChanged<String> onImageUpdated,
  ) async {
    final authBloc = context.read<AuthBloc>();

    try {
      debugPrint('Uploading image file: ${imageFile.path}');
      final imageUrl =
          await authBloc.authService.uploadProfileImage(userId, imageFile);
      debugPrint('Image uploaded successfully. URL: $imageUrl');

      final updatedImageUrl =
          '$imageUrl?v=${DateTime.now().millisecondsSinceEpoch}';
      onImageUpdated(updatedImageUrl);
      if (mounted) {
        setState(() {
          _localProfileImageUrl = updatedImageUrl;
        });
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(localizations.profileImageUpdated)),
      );
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      scaffoldMessenger.showSnackBar(
        SnackBar(
            content: Text('${localizations.errorUploadingProfileImage}: $e')),
      );
    }
  }
}

class EditableFieldsSection extends StatefulWidget {
  final User user;
  final Function(Map<String, dynamic>) onSave;

  const EditableFieldsSection({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  EditableFieldsSectionState createState() => EditableFieldsSectionState();
}

class EditableFieldsSectionState extends State<EditableFieldsSection> {
  bool _isEditing = false;
  bool _isModified = false;
  final Map<String, dynamic> _updatedFields = {};
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController(text: widget.user.firstname);
    _lastNameController = TextEditingController(text: widget.user.lastname);
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
  }

  void _resetControllers() {
    _firstNameController.text = widget.user.firstname;
    _lastNameController.text = widget.user.lastname;
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _setModified() {
    setState(() {
      _isModified = true;
    });
  }

  Future<void> _saveProfile() async {
    final updatedFields = Map<String, dynamic>.from(_updatedFields);
    widget.onSave(updatedFields);
    setState(() {
      _isEditing = false;
      _isModified = false;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _isModified = false;
      _resetControllers();
    });
  }

  Widget _buildEditableField(
      TextEditingController controller, String label, String fieldName) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      enabled: _isEditing,
      onChanged: (value) {
        _updatedFields[fieldName] = value;
        _setModified();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l.editProfile,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                  _isModified = false;
                  if (!_isEditing) {
                    _resetControllers();
                  }
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildEditableField(_firstNameController, l.firstName, 'firstname'),
        const SizedBox(height: 10),
        _buildEditableField(_lastNameController, l.lastName, 'lastname'),
        const SizedBox(height: 10),
        _buildEditableField(_usernameController, l.username, 'username'),
        const SizedBox(height: 10),
        _buildEditableField(_emailController, l.email, 'email'),
        const SizedBox(height: 20),
        if (_isEditing)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isModified ? _saveProfile : null,
                child: Text(l.save),
              ),
              ElevatedButton(
                onPressed: _cancelEditing,
                child: Text(l.cancel),
              ),
            ],
          ),
      ],
    );
  }
}

class LikedGamesList extends StatelessWidget {
  final int? userId;

  const LikedGamesList({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    if (userId == null) {
      return Center(child: Text(l.mustBeLoggedIn));
    }

    return FutureBuilder<List<Like>>(
      future: _fetchLikedGames(userId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(l.noLikedGames));
        } else if (snapshot.hasData) {
          final likes = snapshot.data!;
          if (likes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l.noLikedGames,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: likes.length,
            itemBuilder: (context, index) {
              final like = likes[index];
              final game = like.game;
              return Dismissible(
                key: Key(game.id.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  final likeService = LikeService(Dio());
                  await likeService.deleteLike(like.id!);

                  if (!context.mounted) return;
                  _showToast(context,
                      '${game.name}: ${l.removedFromLikedGames}', Colors.red);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.heart_broken, color: Colors.white),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameDetailPage(game: game),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Image.network(game.imageUrl,
                        width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(game.name),
                    subtitle: Text(game.description),
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List<Like>> _fetchLikedGames(int userId) async {
    final likeService = LikeService(Dio());
    return await likeService.getLikesByUserID(userId);
  }

  void _showToast(BuildContext context, String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomToast(
        message: message,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
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
}

class CachedImageWidget extends StatelessWidget {
  final String url;
  final double size;

  const CachedImageWidget({
    super.key,
    required this.url,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}
