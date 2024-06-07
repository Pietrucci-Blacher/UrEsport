import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/cubit/locale_cubit.dart';
import 'package:uresport/main_screen.dart';
import 'package:uresport/shared/locale_switcher.dart';
import 'package:uresport/core/services/auth_service.dart';

class GlobalScaffold extends StatelessWidget {
  final IAuthService authService;

  const GlobalScaffold({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Stack(
              children: [
                MainScreen(authService: authService),
                Positioned(
                  top: 60.0,
                  right: 30.0,
                  child: LocaleSwitcher(
                    onLocaleChanged: (locale) {
                      context.read<LocaleCubit>().setLocale(locale);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
