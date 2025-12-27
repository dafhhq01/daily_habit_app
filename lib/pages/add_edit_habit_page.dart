import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';

/// Page for adding or editing a habit
class AddEditHabitPage extends StatefulWidget {
  final Habit? edit;
  const AddEditHabitPage({super.key, this.edit});

  @override
  State<AddEditHabitPage> createState() => _AddEditHabitPageState();
}

class _AddEditHabitPageState extends State<AddEditHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();

  /// Habit frequency (daily / weekly)
  String _frequency = 'daily';

  /// Selected habit color in hex format
  String _colorHex = '#4F46E5';

  @override
  void initState() {
    super.initState();

    // If editing an existing habit, preload its values
    if (widget.edit != null) {
      _titleCtrl.text = widget.edit!.title;
      _frequency = widget.edit!.frequency;
      _colorHex = widget.edit!.colorHex;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<HabitService>(context, listen: false);
    final isEdit = widget.edit != null;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(isEdit ? 'Edit Habit' : 'Add Habit')),
      body: SafeArea(
        child: SingleChildScrollView(
          // Bottom padding adapts to keyboard height
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Habit title input
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Habit Name',
                    hintText: 'Example: Drink water',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Habit name is required'
                      : null,
                ),

                const SizedBox(height: 16),

                /// Frequency selector
                DropdownButtonFormField<String>(
                  initialValue: _frequency,
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  ],
                  onChanged: (v) => setState(() => _frequency = v ?? 'daily'),
                  decoration: const InputDecoration(labelText: 'Frequency'),
                ),

                const SizedBox(height: 16),

                /// Color picker preview
                Row(
                  children: [
                    const Text('Color:'),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _pickColorDialog,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _hexToColor(_colorHex),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                /// Save / Add button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final title = _titleCtrl.text.trim();

                        if (isEdit) {
                          final updated = widget.edit!
                            ..title = title
                            ..frequency = _frequency
                            ..colorHex = _colorHex;

                          await service.updateHabit(updated);
                        } else {
                          await service.addHabit(
                            title: title,
                            frequency: _frequency,
                            colorHex: _colorHex,
                          );
                        }

                        if (!context.mounted) return;
                        Navigator.pop(context);
                      }
                    },
                    child: Text(isEdit ? 'Save Changes' : 'Add Habit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Opens a dialog to pick a habit color
  void _pickColorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Choose Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              [
                '#4F46E5',
                '#06B6D4',
                '#059669',
                '#F59E0B',
                '#EF4444',
                '#8B5CF6',
                '#F97316',
              ].map((hex) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _colorHex = hex);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _hexToColor(hex),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  /// Converts hex color string to [Color]
  Color _hexToColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}
