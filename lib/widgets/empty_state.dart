import 'package:flutter/material.dart';

/// Widget displayed when there are no habits available.
/// Encourages the user to create their first habit.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the current theme for consistent colors and text styles
    final theme = Theme.of(context);

    return SafeArea(
      // Enables scrolling in case the content does not fit on smaller screens
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top spacing to vertically center the content
              const SizedBox(height: 80),

              /// Illustration icon to represent an empty state
              Icon(
                Icons.rocket_launch,
                size: 96,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),

              /// Main empty state title
              Text(
                'No habits yet',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              /// Supporting message encouraging user action
              const Text(
                'Add your first habit and start tracking your progress today!',
                textAlign: TextAlign.center,
              ),

              // Bottom spacing for better visual balance
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
