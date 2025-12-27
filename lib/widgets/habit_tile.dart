import 'package:flutter/material.dart';
import '../models/habit.dart';

/// A reusable UI component that displays a single habit item.
/// Shows habit information, streak, frequency, and action buttons.
class HabitTile extends StatelessWidget {
  /// Habit data to be displayed
  final Habit habit;

  /// Callback when habit completion is toggled
  final VoidCallback? onToggle;

  /// Callback when edit button is pressed
  final VoidCallback? onEdit;

  const HabitTile({super.key, required this.habit, this.onToggle, this.onEdit});

  @override
  Widget build(BuildContext context) {
    // Convert stored hex color to Flutter Color
    final color = _hexToColor(habit.colorHex);

    return Card(
      key: key,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        /// Leading icon with habit color
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.checklist, color: color),
        ),

        /// Habit title (strikethrough when completed)
        title: Text(
          habit.title,
          style: TextStyle(
            decoration: habit.isDone ? TextDecoration.lineThrough : null,
          ),
        ),

        /// Habit streak and frequency information
        subtitle: Text('Streak: ${habit.streak} • ${habit.frequency}'),

        /// Action buttons (edit & toggle completion)
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(
              icon: habit.isDone
                  ? const Icon(Icons.check_circle)
                  : const Icon(Icons.circle_outlined),
              onPressed: onToggle,
            ),
          ],
        ),
      ),
    );
  }

  /// Converts a hex color string into a Flutter [Color] object
  Color _hexToColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}
