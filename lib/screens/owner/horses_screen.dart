import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../widgets/common.dart';
import 'horse_form_screen.dart';

class HorsesScreen extends StatelessWidget {
  const HorsesScreen({super.key, required this.ownerId});

  final String ownerId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final horses = store.horsesFor(ownerId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My horses'),
        actions: [
          IconButton(
            tooltip: 'Add horse',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HorseFormScreen(
                    horse: store.newHorseDraft(ownerId),
                    isNew: true,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: horses.isEmpty
          ? EmptyState(
              icon: Icons.pets_outlined,
              title: 'No horses yet',
              message: 'Add a horse with a photo and ownership documents.',
              action: FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HorseFormScreen(
                        horse: store.newHorseDraft(ownerId),
                        isNew: true,
                      ),
                    ),
                  );
                },
                child: const Text('Add horse'),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: horses.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final horse = horses[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: LocalImage(
                      path: horse.photoPath,
                      fallbackIcon: Icons.pets,
                    ),
                    title: Text(horse.name),
                    subtitle: Text(
                      [
                        if (horse.breed.isNotEmpty) horse.breed,
                        if (horse.ownershipDocName != null)
                          'Doc: ${horse.ownershipDocName}',
                      ].join(' · '),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HorseFormScreen(horse: horse),
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
