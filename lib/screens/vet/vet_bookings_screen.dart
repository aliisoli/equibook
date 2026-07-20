import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../models/models.dart';
import '../../settings/app_settings.dart';
import '../../utils/app_dates.dart';
import '../../widgets/common.dart';

class VetBookingsScreen extends StatelessWidget {
  const VetBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final dates = AppDates.watch(context);
    final vetId = store.currentUser!.id;
    final items = store.bookingsForVet(vetId);

    return Scaffold(
      appBar: AppBar(title: Text(s.bookingInbox)),
      body: items.isEmpty
          ? EmptyState(
              icon: Icons.inbox_outlined,
              title: s.noBookingsYet,
              message: s.noBookingsVetMessage,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = items[index];
                final owner = store.userById(booking.ownerId);
                final horse = store.horseById(booking.horseId);
                final service = store.serviceById(booking.serviceId);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                service?.title ?? s.visit,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            StatusChip(status: booking.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(s.ownerLabel(owner?.name ?? s.unknown)),
                        Text(s.horseLabel(horse?.name ?? s.unknown)),
                        Text(dates.formatDateTime(booking.start)),
                        Text(s.quotedRate(dates.formatMoney(booking.quotedRate))),
                        if (booking.notes.isNotEmpty)
                          Text(s.notesLabel(booking.notes)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            if (booking.status == BookingStatus.pending) ...[
                              FilledButton(
                                onPressed: () => store.updateBookingStatus(
                                  booking.id,
                                  BookingStatus.confirmed,
                                ),
                                child: Text(s.accept),
                              ),
                              OutlinedButton(
                                onPressed: () => store.updateBookingStatus(
                                  booking.id,
                                  BookingStatus.declined,
                                ),
                                child: Text(s.decline),
                              ),
                            ],
                            if (booking.status == BookingStatus.confirmed)
                              FilledButton(
                                onPressed: () => store.updateBookingStatus(
                                  booking.id,
                                  BookingStatus.completed,
                                ),
                                child: Text(s.markCompleted),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
