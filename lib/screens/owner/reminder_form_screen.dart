import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../models/models.dart';
import '../../settings/app_settings.dart';
import '../../utils/app_dates.dart';

class ReminderFormScreen extends StatefulWidget {
  const ReminderFormScreen({
    super.key,
    required this.reminder,
    this.isNew = false,
  });

  final HorseReminder reminder;
  final bool isNew;

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  late final TextEditingController _title;
  late String _horseId;
  late ReminderKind _kind;
  late DateTime _dueDate;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.reminder.title);
    _horseId = widget.reminder.horseId;
    _kind = widget.reminder.kind;
    _dueDate = widget.reminder.dueDate;
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final s = context.read<AppSettings>().strings;
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.reminderTitle)),
      );
      return;
    }
    setState(() => _busy = true);
    await context.read<AppStore>().upsertReminder(
      widget.reminder.copyWith(
        horseId: _horseId,
        title: _title.text.trim(),
        dueDate: DateTime(_dueDate.year, _dueDate.month, _dueDate.day),
        kind: _kind,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final dates = AppDates.watch(context);
    final horses = store.horsesFor(store.currentUser!.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNew ? s.addReminder : s.editReminder),
        actions: [
          if (!widget.isNew)
            IconButton(
              onPressed: () async {
                await store.deleteReminder(widget.reminder.id);
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: s.reminderTitle),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            // ignore: deprecated_member_use
            value: horses.any((h) => h.id == _horseId)
                ? _horseId
                : (horses.isEmpty ? null : horses.first.id),
            decoration: InputDecoration(labelText: s.horse),
            items: horses
                .map(
                  (h) => DropdownMenuItem(value: h.id, child: Text(h.name)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _horseId = value);
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ReminderKind>(
            // ignore: deprecated_member_use
            value: _kind,
            decoration: InputDecoration(labelText: s.reminderKind),
            items: ReminderKind.values
                .map(
                  (k) => DropdownMenuItem(
                    value: k,
                    child: Text(s.kindLabel(k)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _kind = value);
            },
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(s.dueDate),
            subtitle: Text(dates.formatDate(_dueDate)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await dates.pickDate(
                context: context,
                initialDate: _dueDate,
                firstDate: DateTime.now().subtract(const Duration(days: 1)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _dueDate = picked);
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(_busy ? s.saving : s.saveReminder),
          ),
        ],
      ),
    );
  }
}
