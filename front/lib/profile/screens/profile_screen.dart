import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/auth/screens/auth_screen.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileScreen extends StatelessWidget {
  final IAuthService authService;

  const ProfileScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authService)..add(AuthCheckRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).profileScreenTitle),
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
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AuthAuthenticated) {
                return _buildProfileScreen(context, state);
              } else {
                return _buildLoginRegisterButtons(context);
              }
            },
          ),
        ),
      ),
    );
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
                    authService: authService,
                    showLogin: true,
                    showRegister: !kIsWeb,
                  ),
                ),
              ).then((_) => context.read<AuthBloc>().add(AuthCheckRequested()));
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

  Widget _buildProfileScreen(BuildContext context, AuthAuthenticated state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).profileScreenWelcome(state.user.username),
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          _buildProfileAvatar(context, state.user.profileImageUrl),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.read<AuthBloc>().add(AuthLoggedOut()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, String? avatarUrl) {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          // Update the user's avatar in the state or database
          // Example: context.read<AuthBloc>().add(UpdateAvatarRequested(pickedFile.path));
        }
      },
      child: CircleAvatar(
        radius: 50,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
        child: avatarUrl == null ? const Icon(Icons.person, size: 50) : null,
      ),
    );
  }
}
