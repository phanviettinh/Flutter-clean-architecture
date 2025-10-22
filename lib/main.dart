import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_ring/config/theme/app_theme.dart';
import 'package:note_ring/config/theme/bloc/theme_bloc.dart';
import 'config/routers/router.dart';
import 'config/theme/bloc/theme_state.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await Firebase.initializeApp();

  // FirebaseCrashlytics.instance.crash();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ThemeBloc>(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: AppRouter.navigatorKey,
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: '/',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}

