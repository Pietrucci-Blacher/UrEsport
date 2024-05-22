import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/auth/bloc/auth_event.dart';
import 'package:uresport/auth/bloc/auth_state.dart';
import 'package:uresport/auth/screens/login_screen.dart';
import 'package:uresport/auth/screens/register_screen.dart';
import 'package:uresport/core/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final IAuthService authService;

  const ProfileScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authService)..add(AuthCheckRequested()),
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AuthAuthenticated) {
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

  Widget _buildLoginRegisterButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You are not logged in',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen(authService: authService)),
              ).then((_) => context.read<AuthBloc>().add(AuthCheckRequested()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Log In'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen(authService: authService)),
              ).then((_) => context.read<AuthBloc>().add(AuthCheckRequested()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Register'),
          ),
          const SizedBox(height: 20),
          const Text('Or login with', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildOAuthButton(context, FontAwesomeIcons.google, const Color(0xFFDB4437), 'Google'),
              const SizedBox(width: 10),
              _buildOAuthButton(context, FontAwesomeIcons.apple, const Color(0xFF000000), 'Apple'),
              const SizedBox(width: 10),
              _buildOAuthButton(context, FontAwesomeIcons.discord, const Color(0xFF5865F2), 'Discord'),
              const SizedBox(width: 10),
              _buildOAuthButton(context, FontAwesomeIcons.twitch, const Color(0xFF9146FF), 'Twitch'),
            ],
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

  Widget _buildProfileScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome to your profile!', style: TextStyle(fontSize: 24)),
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
}
