import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../settings/app_settings.dart';
import '../../utils/app_dates.dart';
import '../../widgets/common.dart';

class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  Future<void> _addSlot(BuildContext context) async {
    final store = context.read<AppStore>();
    final s = context.read<AppSettings>().strings;
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
            final localDates = AppDates.watch(context);
            final localS = context.watch<AppSettings>().strings;
            return AlertDialog(
              title: Text(localS.addAvailability),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(localS.date),
                    subtitle: Text(localDates.formatDate(date)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await localDates.pickDate(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 120)),
                      );
                      if (picked != null) setLocal(() => date = picked);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(localS.start),
                    subtitle: Text(localDates.formatTimeOfDay(context, start)),
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
                    title: Text(localS.end),
                    subtitle: Text(localDates.formatTimeOfDay(context, end)),
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
                  child: Text(localS.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(localS.add),
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
        SnackBar(content: Text(s.endAfterStart)),
      );
      return;
    }
    await store.addSlot(vetId: vetId, start: startDt, end: endDt);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final dates = AppDates.watch(context);
    final vetId = store.currentUser!.id;
    final slots = store.allSlotsFor(vetId);
    final openIds = store.openSlotsFor(vetId).map((slot) => slot.id).toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text(s.availability),
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
              title: s.noAvailability,
              message: s.noAvailabilityMessage,
              action: FilledButton(
                onPressed: () => _addSlot(context),
                child: Text(s.addSlot),
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
                    title: Text(dates.formatDateTime(slot.start)),
                    subtitle: Text(
                      '${s.untilTime(dates.formatTime(slot.end))} · ${s.slotStatus(open)}',
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
