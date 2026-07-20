import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../settings/app_settings.dart';
import '../../theme/mock_ui.dart';
import '../../utils/app_dates.dart';
import '../../widgets/common.dart';
import 'reminder_form_screen.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final dates = AppDates.watch(context);
    final ownerId = store.currentUser!.id;
    final items = store.remindersForOwner(ownerId, includeDone: true);
    final horses = store.horsesFor(ownerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.reminders),
        actions: [
          IconButton(
            onPressed: horses.isEmpty
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReminderFormScreen(
                          reminder: store.newReminderDraft(
                            ownerId,
                            horses.first.id,
                          ),
                          isNew: true,
                        ),
                      ),
                    );
                  },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: items.isEmpty
          ? EmptyState(
              icon: Icons.notifications_none,
              title: s.noReminders,
              message: s.noReminders,
              action: horses.isEmpty
                  ? null
                  : FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ReminderFormScreen(
                              reminder: store.newReminderDraft(
                                ownerId,
                                horses.first.id,
                              ),
                              isNew: true,
                            ),
                          ),
                        );
                      },
                      child: Text(s.addReminder),
                    ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final reminder = items[index];
                final horse = store.horseById(reminder.horseId);
                final days = reminder.dueDate
                    .difference(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      ),
                    )
                    .inDays;
                return Card(
                  color: reminderBg(reminder.kind),
                  child: ListTile(
                    leading: Icon(reminderIcon(reminder.kind)),
                    title: Text(
                      reminder.title,
                      style: TextStyle(
                        decoration:
                            reminder.done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      '${horse?.name ?? s.unknown}\n'
                      '${dates.formatDate(reminder.dueDate)} · ${s.daysLeft(days)}',
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(
                        reminder.done
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                      ),
                      onPressed: () => store.upsertReminder(
                        reminder.copyWith(done: !reminder.done),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ReminderFormScreen(reminder: reminder),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
