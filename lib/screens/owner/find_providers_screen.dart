import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../models/models.dart';
import '../../settings/app_settings.dart';
import '../../widgets/common.dart';
import 'provider_detail_screen.dart';

class FindProvidersScreen extends StatefulWidget {
  const FindProvidersScreen({super.key, required this.category});

  final ServiceCategory category;

  @override
  State<FindProvidersScreen> createState() => _FindProvidersScreenState();
}

class _FindProvidersScreenState extends State<FindProvidersScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final providers = store.providersFor(widget.category).where((provider) {
      final profile = store.profileFor(provider.id);
      final haystack =
          '${provider.name} ${profile.serviceArea} ${profile.bio}'.toLowerCase();
      return haystack.contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(s.categoryTitle(widget.category))),
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
            child: providers.isEmpty
                ? EmptyState(
                    icon: Icons.search_off,
                    title: s.noVetsFound,
                    message: s.noVetsMessage,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: providers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final provider = providers[index];
                      final profile = store.profileFor(provider.id);
                      final serviceCount =
                          store.servicesFor(provider.id).length;
                      final openSlots = store.openSlotsFor(provider.id).length;
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(provider.name),
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
                              Text(
                                s.servicesAndSlots(serviceCount, openSlots),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProviderDetailScreen(
                                  providerId: provider.id,
                                ),
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
