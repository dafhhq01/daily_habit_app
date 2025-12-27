import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/habit_service.dart';

/// Settings page that handles data management features
/// such as export, import, and reset.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  /// Shows a dialog for exporting habit data as JSON
  void _showExportDialog(BuildContext context) {
    final service = context.read<HabitService>();
    final bool hasData = service.hasData();

    // If there is no data to export, show an informational dialog
    if (!hasData) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Export Backup'),
          content: const Text(
            'There is no habit data to export.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
      return;
    }

    // Convert habit data to JSON string
    final String jsonData = service.exportJson();

    // Show export dialog with selectable JSON text
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Export Backup'),
        content: SingleChildScrollView(child: SelectableText(jsonData)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
            onPressed: () async {
              // Copy JSON data to clipboard
              await Clipboard.setData(ClipboardData(text: jsonData));

              if (!context.mounted) return;
              Navigator.pop(context);

              // Show confirmation snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data copied successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access HabitService without listening to changes
    final service = Provider.of<HabitService>(context, listen: false);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          children: [
            /// EXPORT SECTION
            ListTile(
              title: const Text('Export backup (JSON)'),
              trailing: const Icon(Icons.download),
              onTap: () => _showExportDialog(context),
            ),
            const Divider(),

            /// IMPORT SECTION
            ListTile(
              title: const Text('Import backup (JSON)'),
              subtitle: const Text('Paste JSON backup'),
              trailing: const Icon(Icons.upload),
              onTap: () async {
                final controller = TextEditingController();

                // Show import confirmation dialog
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Import JSON'),
                    content: SingleChildScrollView(
                      child: TextField(
                        controller: controller,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          hintText: 'Paste JSON backup here',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Import'),
                      ),
                    ],
                  ),
                );

                // Validate and import JSON data
                if (confirm == true && controller.text.trim().isNotEmpty) {
                  try {
                    await service.importJson(controller.text.trim());
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Import completed successfully'),
                      ),
                    );
                  } catch (_) {
                    // Show error if JSON format is invalid
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid JSON format')),
                    );
                  }
                }
              },
            ),
            const Divider(),

            /// RESET SECTION
            ListTile(
              title: const Text('Reset all data'),
              trailing: const Icon(Icons.delete_forever),
              onTap: () async {
                // Ask for user confirmation before deleting all data
                final yes = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Reset data?'),
                    content: const Text(
                      'All data will be permanently deleted.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );

                // Clear all data if user confirms
                if (yes == true) {
                  await service.clearAll();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All data has been reset')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
