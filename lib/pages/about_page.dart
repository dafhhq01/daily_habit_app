import 'package:flutter/material.dart';

/// About page that displays application information
/// such as description, features, and technology used.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current theme for consistent styling
    final theme = Theme.of(context);

    return SafeArea(
      // Allows the content to be scrollable if it overflows
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Application title
            Text(
              'Daily Habit',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            /// Application description
            const Text(
              'This app helps you build small daily habits to become more consistent and productive.',
            ),
            const SizedBox(height: 16),

            /// Features section title
            const Text(
              'Features:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            /// List of available features
            const Text(
              '• Add / Edit habits\n'
              '• Mark habits as completed\n'
              '• Simple statistics\n'
              '• Backup / Restore (JSON export)',
            ),
            const SizedBox(height: 16),

            /// Technology information
            const Text('Built with Flutter.'),

            /// Extra spacing at the bottom for better scroll experience
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
