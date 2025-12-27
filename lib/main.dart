import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/splash_page.dart';
import 'services/habit_service.dart';

/// Application entry point
void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
/// Sets up global providers, themes, and initial route.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provide HabitService to the entire widget tree
      create: (_) => HabitService(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Daily Habit',

            /// Light theme configuration
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: const Color(0xFF4F46E5),
              brightness: Brightness.light,
            ),

            /// Dark theme configuration
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: const Color(0xFF6D28D9),
              brightness: Brightness.dark,
            ),

            /// Automatically switch theme based on system settings
            themeMode: ThemeMode.system,

            /// Initial screen displayed when the app launches
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
