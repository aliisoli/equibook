import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../settings/app_settings.dart';
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
    final s = context.watch<AppSettings>().strings;
    final vets = store.vets.where((vet) {
      final profile = store.profileFor(vet.id);
      final haystack =
          '${vet.name} ${profile.serviceArea} ${profile.bio}'.toLowerCase();
      return haystack.contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(s.findVets)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: s.searchVetsHint,
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: vets.isEmpty
                ? EmptyState(
                    icon: Icons.search_off,
                    title: s.noVetsFound,
                    message: s.noVetsMessage,
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
                                    ? s.serviceAreaNotSet
                                    : profile.serviceArea,
                              ),
                              const SizedBox(height: 4),
                              Text(s.servicesAndSlots(serviceCount, openSlots)),
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
