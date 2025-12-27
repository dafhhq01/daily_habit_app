# Daily Habit App

A Flutter application for tracking daily habits with streak tracking, JSON backup, and undo delete support.

## ✨ Features
- Add, edit, and delete habits
- Mark habits as completed (daily streak)
- Swipe to delete + Undo
- Reorder habits
- Habit statistics
- Backup & restore via JSON
- Automatic dark mode

## 🚀 How to Run
1. Make sure Flutter is installed
2. Run:
   flutter pub get
   flutter run

## 🔄 Backup & Restore
- Export: Settings → Export backup (JSON)
- Import: Paste JSON into the Import menu

## 🏗️ Project Architecture
```text
submission\lib/
 ├── models/
 │    └── habit.dart
 ├── pages/
 │    ├── about_page.dart
 │    ├── add_edit_habit_page.dart
 │    ├── home_page.dart
 │    ├── settings_page.dart
 │    ├── splash_page.dart
 │    └── stats_page.dart
 ├── services/
 │    └── habit_service.dart
 ├── widgets/
 │    ├── empty_state.dart
 │    └── habit_tile.dart
 └── main.dart
```
## 🛠 Technologies
- Flutter (Material 3)
- Provider
- SharedPreferences

## 📌 Notes
Data is stored locally using SharedPreferences.