import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../widgets/common.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  Future<void> _addSlot(BuildContext context) async {
    final store = context.read<AppStore>();
    final vetId = store.currentUser!.id;
    final now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day).add(
      const Duration(days: 1),
    );
    TimeOfDay start = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay end = const TimeOfDay(hour: 10, minute: 0);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              title: const Text('Add availability'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Date'),
                    subtitle: Text(dateFormat.format(date)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 120)),
                      );
                      if (picked != null) setLocal(() => date = picked);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Start'),
                    subtitle: Text(start.format(context)),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: start,
                      );
                      if (picked != null) setLocal(() => start = picked);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('End'),
                    subtitle: Text(end.format(context)),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: end,
                      );
                      if (picked != null) setLocal(() => end = picked);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true || !context.mounted) return;
    final startDt = DateTime(
      date.year,
      date.month,
      date.day,
      start.hour,
      start.minute,
    );
    final endDt = DateTime(
      date.year,
      date.month,
      date.day,
      end.hour,
      end.minute,
    );
    if (!endDt.isAfter(startDt)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time.')),
      );
      return;
    }
    await store.addSlot(vetId: vetId, start: startDt, end: endDt);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final vetId = store.currentUser!.id;
    final slots = store.allSlotsFor(vetId);
    final openIds = store.openSlotsFor(vetId).map((s) => s.id).toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Availability'),
        actions: [
          IconButton(
            onPressed: () => _addSlot(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: slots.isEmpty
          ? EmptyState(
              icon: Icons.calendar_month_outlined,
              title: 'No availability',
              message: 'Add time slots owners can book.',
              action: FilledButton(
                onPressed: () => _addSlot(context),
                child: const Text('Add slot'),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: slots.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final slot = slots[index];
                final open = openIds.contains(slot.id);
                return Card(
                  child: ListTile(
                    title: Text(dateTimeFormat.format(slot.start)),
                    subtitle: Text(
                      'Until ${timeFormat.format(slot.end)} · ${open ? 'Open' : 'Booked / past'}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => store.deleteSlot(slot.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
