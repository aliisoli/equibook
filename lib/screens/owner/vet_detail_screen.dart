import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../widgets/common.dart';
import 'book_visit_screen.dart';

class VetDetailScreen extends StatelessWidget {
  const VetDetailScreen({super.key, required this.vetId});

  final String vetId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final vet = store.userById(vetId);
    if (vet == null) {
      return const Scaffold(body: Center(child: Text('Vet not found')));
    }
    final profile = store.profileFor(vetId);
    final services = store.servicesFor(vetId);
    final slots = store.openSlotsFor(vetId);

    return Scaffold(
      appBar: AppBar(title: Text(vet.name)),
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
                        ? 'Equine veterinarian'
                        : profile.credentials,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.bio.isEmpty ? 'No bio yet.' : profile.bio,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          profile.serviceArea.isEmpty
                              ? 'Service area not set'
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
          const SectionHeader('Services & rates'),
          const SizedBox(height: 8),
          if (services.isEmpty)
            const Text('This vet has not listed services yet.')
          else
            ...services.map(
              (service) => Card(
                child: ListTile(
                  title: Text(service.title),
                  subtitle: Text(
                    service.description.isEmpty
                        ? '${service.durationMinutes} min'
                        : '${service.description}\n${service.durationMinutes} min',
                  ),
                  isThreeLine: service.description.isNotEmpty,
                  trailing: Text(
                    moneyFormat.format(service.rate),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          SectionHeader('Open times (${slots.length})'),
          const SizedBox(height: 8),
          if (slots.isEmpty)
            const Text('No open slots right now.')
          else
            ...slots.take(5).map(
              (slot) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule),
                title: Text(dateTimeFormat.format(slot.start)),
                subtitle: Text('Until ${timeFormat.format(slot.end)}'),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: services.isEmpty || slots.isEmpty
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BookVisitScreen(vetId: vetId),
                      ),
                    );
                  },
            child: const Text('Book a visit'),
          ),
          const SizedBox(height: 8),
          Text(
            'Payment is cash offline. You will confirm the rate before sending the request.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
