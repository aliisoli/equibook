import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../settings/app_settings.dart';
import '../../widgets/preferences_section.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final user = store.currentUser!;

    return Scaffold(
      appBar: AppBar(title: Text(s.profile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(user.name),
            subtitle: Text('${user.email}\n${s.roleOwner}'),
            isThreeLine: true,
          ),
          const Divider(),
          const PreferencesSection(),
          const Divider(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout),
            title: Text(s.logOut),
            onTap: () => store.logout(),
          ),
        ],
      ),
    );
  }
}
