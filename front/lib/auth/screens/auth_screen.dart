import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/auth/screens/login_screen.dart';
import 'package:uresport/auth/screens/register_screen.dart';
import 'package:uresport/auth/screens/reset_password_screen.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthScreen extends StatelessWidget {
  final IAuthService authService;
  final bool showLogin;
  final bool showRegister;

  const AuthScreen({super.key, required this.authService, this.showLogin = true, this.showRegister = true});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authService)..add(AuthCheckRequested()),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
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
          if (showLogin)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(authService: authService),
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
          const SizedBox(height: 10),
          if (showRegister && !kIsWeb)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(authService: authService),
                  ),
                ).then((_) => context.read<AuthBloc>().add(AuthCheckRequested()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(AppLocalizations.of(context).register),
            ),
          const SizedBox(height: 20),
          if (showLogin)
            Text(AppLocalizations.of(context).orLoginWith,
                style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          if (showLogin)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildOAuthButton(context, FontAwesomeIcons.google,
                    const Color(0xFFDB4437), 'Google'),
                const SizedBox(width: 10),
                _buildOAuthButton(context, FontAwesomeIcons.apple,
                    const Color(0xFF000000), 'Apple'),
                const SizedBox(width: 10),
                _buildOAuthButton(context, FontAwesomeIcons.discord,
                    const Color(0xFF5865F2), 'Discord'),
                const SizedBox(width: 10),
                _buildOAuthButton(context, FontAwesomeIcons.twitch,
                    const Color(0xFF9146FF), 'Twitch'),
              ],
            ),
          const SizedBox(height: 20),
          if (showLogin)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(authService: authService),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context).forgotPassword),
            ),
        ],
      ),
    );
  }

  Widget _buildOAuthButton(BuildContext context, IconData icon, Color color, String provider) {
    return GestureDetector(
      onTap: () => context.read<AuthBloc>().add(OAuthLoginRequested(provider)),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FaIcon(icon, color: Colors.white, size: 24),
        ),
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
        //final picker = ImagePicker();
        //final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        //if (pickedFile != null) {
          // Update the user's avatar in the state or database
          // Example: context.read<AuthBloc>().add(UpdateAvatarRequested(pickedFile.path));
        //}
      },
      child: CircleAvatar(
        radius: 50,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
        child: avatarUrl == null ? const Icon(Icons.person, size: 50) : null,
      ),
    );
  }
}
