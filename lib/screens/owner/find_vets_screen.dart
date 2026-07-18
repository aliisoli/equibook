import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../widgets/common.dart';
import 'vet_detail_screen.dart';

class FindVetsScreen extends StatefulWidget {
  const FindVetsScreen({super.key});

  @override
  State<FindVetsScreen> createState() => _FindVetsScreenState();
}

class _FindVetsScreenState extends State<FindVetsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final vets = store.vets.where((vet) {
      final profile = store.profileFor(vet.id);
      final haystack =
          '${vet.name} ${profile.serviceArea} ${profile.bio}'.toLowerCase();
      return haystack.contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Find vets')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name or area',
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: vets.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off,
                    title: 'No vets found',
                    message: 'Try another search, or ask a vet to sign up.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: vets.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final vet = vets[index];
                      final profile = store.profileFor(vet.id);
                      final serviceCount = store.servicesFor(vet.id).length;
                      final openSlots = store.openSlotsFor(vet.id).length;
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(vet.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text(
                                profile.serviceArea.isEmpty
                                    ? 'Service area not set'
                                    : profile.serviceArea,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$serviceCount services · $openSlots open slots',
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => VetDetailScreen(vetId: vet.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
