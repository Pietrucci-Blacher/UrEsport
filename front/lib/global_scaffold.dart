import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/cubit/locale_cubit.dart';
import 'package:uresport/main_screen.dart';
import 'package:uresport/shared/locale_switcher.dart';

class GlobalScaffold extends StatelessWidget {
  const GlobalScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Stack(
              children: [
                const MainScreen(),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LocaleSwitcher(
                      onLocaleChanged: (locale) {
                        context.read<LocaleCubit>().setLocale(locale);
                      },
                    ),
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