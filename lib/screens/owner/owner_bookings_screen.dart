import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../models/models.dart';
import '../../settings/app_settings.dart';
import '../../utils/app_dates.dart';
import '../../widgets/common.dart';

class OwnerBookingsScreen extends StatelessWidget {
  const OwnerBookingsScreen({super.key, required this.ownerId});

  final String ownerId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final dates = AppDates.watch(context);
    final items = store.bookingsForOwner(ownerId);

    return Scaffold(
      appBar: AppBar(title: Text(s.myBookings)),
      body: items.isEmpty
          ? EmptyState(
              icon: Icons.event_available_outlined,
              title: s.noBookingsYet,
              message: s.noBookingsOwnerMessage,
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
                                service?.title ?? s.visit,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            StatusChip(status: booking.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(vet?.name ?? s.vet),
                        Text(s.horseLabel(horse?.name ?? s.unknown)),
                        Text(dates.formatDateTime(booking.start)),
                        Text(
                          s.confirmedRateLine(
                            dates.formatMoney(booking.quotedRate),
                          ),
                        ),
                        if (booking.status == BookingStatus.pending ||
                            booking.status == BookingStatus.confirmed) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton(
                              onPressed: () => store.updateBookingStatus(
                                booking.id,
                                BookingStatus.cancelled,
                              ),
                              child: Text(s.cancel),
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
