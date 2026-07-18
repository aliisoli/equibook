import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../models/models.dart';
import '../../widgets/common.dart';

class VetBookingsScreen extends StatelessWidget {
  const VetBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final vetId = store.currentUser!.id;
    final items = store.bookingsForVet(vetId);

    return Scaffold(
      appBar: AppBar(title: const Text('Booking inbox')),
      body: items.isEmpty
          ? const EmptyState(
              icon: Icons.inbox_outlined,
              title: 'No bookings yet',
              message:
                  'When owners request visits, they appear here for accept or decline.',
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
                                service?.title ?? 'Visit',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            StatusChip(status: booking.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Owner: ${owner?.name ?? 'Unknown'}'),
                        Text('Horse: ${horse?.name ?? 'Unknown'}'),
                        Text(dateTimeFormat.format(booking.start)),
                        Text(
                          'Quoted rate: ${moneyFormat.format(booking.quotedRate)}',
                        ),
                        if (booking.notes.isNotEmpty) Text('Notes: ${booking.notes}'),
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
                                child: const Text('Accept'),
                              ),
                              OutlinedButton(
                                onPressed: () => store.updateBookingStatus(
                                  booking.id,
                                  BookingStatus.declined,
                                ),
                                child: const Text('Decline'),
                              ),
                            ],
                            if (booking.status == BookingStatus.confirmed)
                              FilledButton(
                                onPressed: () => store.updateBookingStatus(
                                  booking.id,
                                  BookingStatus.completed,
                                ),
                                child: const Text('Mark completed'),
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
