import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';

/// Service class that manages all habit-related operations,
/// including CRUD, persistence, statistics, and backup.
class HabitService extends ChangeNotifier {
  /// Key used to store habits in SharedPreferences
  static const String storageKey = 'habits_v1';

  /// Internal list of habits
  final List<Habit> _habits = [];

  /// UUID generator for habit IDs
  final Uuid _uuid = const Uuid();

  /// Read-only access to habits list
  List<Habit> get habits => List.unmodifiable(_habits);

  /// Check whether there is any habit data
  bool hasData() => _habits.isNotEmpty;

  /// Initialize service and load data from local storage
  HabitService() {
    _loadFromStorage();
  }

  // ---------------------------------------------------------------------------
  // STORAGE
  // ---------------------------------------------------------------------------

  /// Load habit data from SharedPreferences
  Future<void> _loadFromStorage() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(storageKey);
    if (raw == null) return;

    try {
      final List decoded = json.decode(raw);
      _habits
        ..clear()
        ..addAll(
          decoded.map((e) => Habit.fromMap(Map<String, dynamic>.from(e))),
        );
      notifyListeners();
    } catch (_) {
      // Ignore corrupted or invalid stored data
    }
  }

  /// Save current habit list to SharedPreferences
  Future<void> _saveToStorage() async {
    final sp = await SharedPreferences.getInstance();
    final encoded = json.encode(_habits.map((h) => h.toMap()).toList());
    await sp.setString(storageKey, encoded);
  }

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// Add a new habit
  Future<void> addHabit({
    required String title,
    String frequency = 'daily',
    String colorHex = '#4F46E5',
    String icon = '0xe3af',
  }) async {
    final habit = Habit(
      id: _uuid.v4(),
      title: title,
      frequency: frequency,
      colorHex: colorHex,
      icon: icon,
    );

    _habits.insert(0, habit);
    await _saveToStorage();
    notifyListeners();
  }

  /// Update an existing habit
  Future<void> updateHabit(Habit updated) async {
    final idx = _habits.indexWhere((h) => h.id == updated.id);
    if (idx == -1) return;

    _habits[idx] = updated;
    await _saveToStorage();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // TOGGLE + STREAK
  // ---------------------------------------------------------------------------

  /// Toggle habit completion state and manage streak logic
  Future<void> toggleHabit(String id) async {
    final idx = _habits.indexWhere((h) => h.id == id);
    if (idx == -1) return;

    final habit = _habits[idx];
    final now = DateTime.now();

    if (!habit.isDone) {
      final last = habit.lastCompleted;

      // Check if the habit was already completed today
      final isSameDay =
          last != null &&
          last.year == now.year &&
          last.month == now.month &&
          last.day == now.day;

      if (!isSameDay) {
        if (last != null) {
          final yesterday = now.subtract(const Duration(days: 1));
          final wasYesterday =
              last.year == yesterday.year &&
              last.month == yesterday.month &&
              last.day == yesterday.day;

          // Continue streak if completed yesterday, otherwise reset
          habit.streak = wasYesterday ? habit.streak + 1 : 1;
        } else {
          habit.streak = 1;
        }

        // Update longest streak if needed
        if (habit.streak > habit.longestStreak) {
          habit.longestStreak = habit.streak;
        }

        habit.lastCompleted = now;
      }

      habit.isDone = true;
    } else {
      // Uncheck habit without modifying streak history
      habit.isDone = false;
    }

    await _saveToStorage();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // DELETE + UNDO SUPPORT
  // ---------------------------------------------------------------------------

  /// Remove a habit by ID and return it (used for undo functionality)
  Habit removeById(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    final removed = _habits.removeAt(index);
    _saveToStorage();
    notifyListeners();
    return removed;
  }

  /// Insert a habit back at a specific index (undo support)
  void insertAt(int index, Habit habit) {
    _habits.insert(index, habit);
    _saveToStorage();
    notifyListeners();
  }

  /// Permanently delete a habit by ID
  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((h) => h.id == id);
    await _saveToStorage();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // REORDER
  // ---------------------------------------------------------------------------

  /// Reorder habits (used with drag & drop)
  Future<void> reorderHabit(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final habit = _habits.removeAt(oldIndex);
    _habits.insert(newIndex, habit);
    await _saveToStorage();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // RESET
  // ---------------------------------------------------------------------------

  /// Remove all habit data
  Future<void> clearAll() async {
    _habits.clear();
    await _saveToStorage();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // BACKUP (JSON)
  // ---------------------------------------------------------------------------

  /// Export all habits as a JSON string
  String exportJson() {
    return json.encode(_habits.map((h) => h.toMap()).toList());
  }

  /// Import habits from JSON and overwrite existing data
  Future<void> importJson(String raw) async {
    final List decoded = json.decode(raw);
    _habits
      ..clear()
      ..addAll(decoded.map((e) => Habit.fromMap(Map<String, dynamic>.from(e))));
    await _saveToStorage();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // STATS
  // ---------------------------------------------------------------------------

  /// Total number of habits
  int totalHabits() => _habits.length;

  /// Number of habits completed today
  int totalCompletedToday() {
    final now = DateTime.now();
    return _habits.where((h) {
      final d = h.lastCompleted;
      return d != null &&
          d.year == now.year &&
          d.month == now.month &&
          d.day == now.day;
    }).length;
  }

  /// Longest streak achieved across all habits
  int longestStreakOverall() {
    if (_habits.isEmpty) return 0;
    return _habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b);
  }
}
