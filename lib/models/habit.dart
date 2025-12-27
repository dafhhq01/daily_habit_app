import 'dart:convert';

class Habit {
  String id;
  String title;
  bool isDone;
  int streak; // current consecutive days
  int longestStreak;
  DateTime? lastCompleted;
  String colorHex; // store color as hex
  String icon; // material icon codepoint stored as string
  String frequency; // "daily" or "weekly" etc.
  DateTime createdAt;

  Habit({
    required this.id,
    required this.title,
    this.isDone = false,
    this.streak = 0,
    this.longestStreak = 0,
    this.lastCompleted,
    this.colorHex = '#4F46E5', // default indigo-ish
    this.icon =
        '0xe3af', // default icon codepoint as string - (use Icons.check)
    this.frequency = 'daily',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'] ?? false,
      streak: map['streak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      lastCompleted: map['lastCompleted'] != null
          ? DateTime.parse(map['lastCompleted'])
          : null,
      colorHex: map['colorHex'] ?? '#4F46E5',
      icon: map['icon'] ?? '0xe3af',
      frequency: map['frequency'] ?? 'daily',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'streak': streak,
      'longestStreak': longestStreak,
      'lastCompleted': lastCompleted?.toIso8601String(),
      'colorHex': colorHex,
      'icon': icon,
      'frequency': frequency,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source));
}
