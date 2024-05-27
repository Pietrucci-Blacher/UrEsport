import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/shared/routing/routing.dart';
import 'package:uresport/cubit/locale_cubit.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/shared/splash_screen/splash_screen_handler.dart';
import 'package:uresport/auth/bloc/auth_bloc.dart';
import 'package:uresport/core/services/auth_service.dart';

class MyApp extends StatelessWidget {
  final IAuthService authService;

  const MyApp({required this.authService, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleCubit(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(authService),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'UrEsport',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('es', ''),
              Locale('fr', ''),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) {
                return const Locale('en', '');
              }
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
              return const Locale('en', '');
            },
            home: const SplashScreenHandler(),
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
            builder: (context, child) {
              return child!;
            },
          );
        },
      ),
    );
  }
}
