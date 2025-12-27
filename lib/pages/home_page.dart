import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/habit_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/habit_tile.dart';
import 'add_edit_habit_page.dart';
import 'stats_page.dart';
import 'about_page.dart';
import 'settings_page.dart';

/// Main entry page of the app.
/// Hosts bottom navigation and switches between tabs.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Currently selected bottom navigation index
  int _selectedIndex = 0;

  // Used to show SnackBars from outside the Scaffold context
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  /// Navigate to Add/Edit Habit page
  void _onAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditHabitPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access habit data and actions from service
    final service = Provider.of<HabitService>(context);

    // Tab pages controlled by BottomNavigationBar
    final tabs = [
      _buildHomeTab(service),
      const StatsPage(),
      const AboutPage(),
      const SettingsPage(),
    ];

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('Daily Habit')),

        // Display selected tab content
        body: SafeArea(child: tabs[_selectedIndex]),

        // FAB only appears on Home tab
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: _onAdd,
                child: const Icon(Icons.add),
              )
            : null,

        // Bottom navigation for main sections
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              label: 'About',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  /// Home tab displaying the list of habits
  Widget _buildHomeTab(HabitService service) {
    final habits = service.habits;

    // Empty state when no habits exist
    if (habits.isEmpty) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: 400, child: Center(child: EmptyState())),
      );
    }

    // Reorderable list of habits
    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: habits.length,
      onReorder: (oldIndex, newIndex) async {
        await service.reorderHabit(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final h = habits[index];

        return Dismissible(
          key: ValueKey(h.id),
          direction: DismissDirection.endToStart,

          // Background shown when swiping to delete
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),

          // Confirm before deleting a habit
          confirmDismiss: (_) async {
            final result = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Delete habit?'),
                content: const Text(
                  'Are you sure you want to delete this habit?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
            return result == true;
          },

          // Handle habit removal and undo action
          onDismissed: (_) {
            final removedIndex = index;
            final removedHabit = service.removeById(h.id);

            _scaffoldKey.currentState?.clearSnackBars();
            _scaffoldKey.currentState?.showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 4),
                content: Text('Habit "${removedHabit.title}" deleted'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    service.insertAt(removedIndex, removedHabit);
                  },
                ),
              ),
            );
          },

          // Habit list item
          child: HabitTile(
            key: ValueKey(h.id),
            habit: h,
            onToggle: () async => await service.toggleHabit(h.id),
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEditHabitPage(edit: h)),
              );
            },
          ),
        );
      },
    );
  }
}
