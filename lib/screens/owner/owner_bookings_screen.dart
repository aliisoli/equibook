import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../models/models.dart';
import '../../widgets/common.dart';

class OwnerBookingsScreen extends StatelessWidget {
  const OwnerBookingsScreen({super.key, required this.ownerId});

  final String ownerId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final items = store.bookingsForOwner(ownerId);

    return Scaffold(
      appBar: AppBar(title: const Text('My bookings')),
      body: items.isEmpty
          ? const EmptyState(
              icon: Icons.event_available_outlined,
              title: 'No bookings yet',
              message: 'Find a vet and request a visit for one of your horses.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = items[index];
                final vet = store.userById(booking.vetId);
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
                        Text(vet?.name ?? 'Vet'),
                        Text('Horse: ${horse?.name ?? 'Unknown'}'),
                        Text(dateTimeFormat.format(booking.start)),
                        Text(
                          'Confirmed rate: ${moneyFormat.format(booking.quotedRate)} (cash offline)',
                        ),
                        if (booking.status == BookingStatus.pending ||
                            booking.status == BookingStatus.confirmed) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => store.updateBookingStatus(
                                booking.id,
                                BookingStatus.cancelled,
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
