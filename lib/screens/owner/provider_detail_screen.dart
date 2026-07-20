import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../settings/app_settings.dart';
import '../../utils/app_dates.dart';
import '../../widgets/common.dart';
import 'book_service_screen.dart';

class ProviderDetailScreen extends StatelessWidget {
  const ProviderDetailScreen({super.key, required this.providerId});

  final String providerId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final dates = AppDates.watch(context);
    final provider = store.userById(providerId);
    if (provider == null) {
      return Scaffold(body: Center(child: Text(s.providerNotFound)));
    }
    final profile = store.profileFor(providerId);
    final services = store.servicesFor(providerId);
    final slots = store.openSlotsFor(providerId);

    return Scaffold(
      appBar: AppBar(title: Text(provider.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.credentials.isEmpty
                        ? s.categoryTitle(profile.category)
                        : profile.credentials,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(profile.bio.isEmpty ? s.noBioYet : profile.bio),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          profile.serviceArea.isEmpty
                              ? s.serviceAreaNotSet
                              : profile.serviceArea,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(s.servicesAndRates),
          const SizedBox(height: 8),
          if (services.isEmpty)
            Text(s.noServicesListed)
          else
            ...services.map(
              (service) => Card(
                child: ListTile(
                  title: Text(service.title),
                  subtitle: Text(
                    service.description.isEmpty
                        ? s.minutesLabel(service.durationMinutes)
                        : '${service.description}\n${s.minutesLabel(service.durationMinutes)}',
                  ),
                  isThreeLine: service.description.isNotEmpty,
                  trailing: Text(
                    dates.formatMoney(service.rate),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          SectionHeader(s.openTimes(slots.length)),
          const SizedBox(height: 8),
          if (slots.isEmpty)
            Text(s.noOpenSlots)
          else
            ...slots.take(5).map(
              (slot) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule),
                title: Text(dates.formatDateTime(slot.start)),
                subtitle: Text(s.untilTime(dates.formatTime(slot.end))),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: services.isEmpty || slots.isEmpty
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            BookServiceScreen(providerId: providerId),
                      ),
                    );
                  },
            child: Text(s.bookAVisit),
          ),
          const SizedBox(height: 8),
          Text(s.cashOfflineHint, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
