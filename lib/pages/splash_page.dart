import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';

/// Splash screen displayed when the app is first launched.
/// Shows the app logo and navigates to the HomePage after a short delay.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Delay navigation to allow splash screen to be visible
    Timer(const Duration(milliseconds: 900), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme for consistent styling
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// App icon shown on splash screen
              Icon(
                Icons.auto_awesome_mosaic,
                size: 84,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),

              /// Application name
              Text(
                'Daily Habit',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              /// Loading indicator while navigating to HomePage
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
