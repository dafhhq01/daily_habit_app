# Daily Habit App

Daily Habit App is a Flutter mobile application designed to help users build and maintain daily habits through simple progress tracking. The application allows users to manage habits, record daily completion, monitor streaks, view statistics, and safely back up or restore data using JSON. All application data is stored locally on the device using SharedPreferences.

---

# Features

- **Habit Management**
  - Add new habits.
  - Edit existing habits.
  - Delete habits.

- **Daily Tracking**
  - Mark habits as completed.
  - Track daily completion streaks.

- **Productivity Tools**
  - Swipe to delete with Undo support.
  - Reorder habits using drag-and-drop.
  - View habit statistics.

- **Backup & Restore**
  - Export habit data as JSON.
  - Restore habit data from JSON backup.

- **Appearance**
  - Automatic dark mode support.

---

# Project Architecture

The project is organized into separate layers for models, pages, services, and reusable widgets to improve maintainability.

```text
lib/
├── models/
│   └── habit.dart
│
├── pages/
│   ├── about_page.dart
│   ├── add_edit_habit_page.dart
│   ├── home_page.dart
│   ├── settings_page.dart
│   ├── splash_page.dart
│   └── stats_page.dart
│
├── services/
│   └── habit_service.dart
│
├── widgets/
│   ├── empty_state.dart
│   └── habit_tile.dart
│
└── main.dart
```

### Directory Description

| Directory | Description |
|------------|-------------|
| `models` | Data models used by the application |
| `pages` | Main application screens |
| `services` | Business logic and local data management |
| `widgets` | Reusable user interface components |
| `main.dart` | Application entry point |

---

# How It Works

## 1. Create and Manage Habits

Users can add, edit, reorder, and delete habits directly from the application.

Deleted habits can be restored immediately using the Undo action.

---

## 2. Track Daily Progress

Each habit can be marked as completed once per day.

The application records completion history and updates the current streak.

---

## 3. View Statistics

The Statistics page provides an overview of habit progress based on the recorded completion data.

---

## 4. Backup & Restore

Habit data can be exported as a JSON backup.

To restore data, import a previously exported JSON file from the Settings page.

---

# Deployment & Setup

## Prerequisites

Before running the application, ensure that you have:

- Flutter SDK installed.
- Android Studio or Visual Studio Code.
- Android SDK or an emulator.

---

## Installation

### Clone the Repository

```bash
git clone https://github.com/yourusername/daily_habit_app.git
cd daily_habit_app
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run
```

### Build Release APK

```bash
flutter build apk --release
```

---

# Technologies & Libraries

## Framework

- Flutter
- Material 3

## State Management

- Provider

## Local Storage

- SharedPreferences

---

# Data Storage

All habit data is stored locally using **SharedPreferences**.

No user account, cloud database, or internet connection is required for the core functionality of the application.

---

# Notes

- All data is stored locally on the device.
- Backup files use JSON format for portability.
- Importing a backup restores the saved habit data.
- The project follows a modular Flutter project structure to separate presentation, business logic, and data management.

---

# License

This project was developed for educational purposes and Flutter application development practice.
