import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/habit_service.dart';

/// Statistics summary page (read-only)
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve statistics data from HabitService
    final service = Provider.of<HabitService>(context);

    return SafeArea(
      child: SingleChildScrollView(
        // Bottom padding to avoid overlap with FAB / bottom navigation
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Total number of registered habits
            Card(
              child: ListTile(
                title: const Text('Total Habits'),
                trailing: Text('${service.totalHabits()}'),
              ),
            ),
            const SizedBox(height: 8),

            // Habits completed today
            Card(
              child: ListTile(
                title: const Text('Completed Today'),
                trailing: Text('${service.totalCompletedToday()}'),
              ),
            ),
            const SizedBox(height: 8),

            // Longest streak achieved
            Card(
              child: ListTile(
                title: const Text('Longest Streak'),
                trailing: Text('${service.longestStreakOverall()}'),
              ),
            ),

            const SizedBox(height: 24),

            // Motivational tip, centered without affecting main alignment
            Align(
              alignment: Alignment.center,
              child: Text(
                'Tip: Consistency > intensity.\n'
                'Focus on completing one habit consistently first.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
