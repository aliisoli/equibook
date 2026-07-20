import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../settings/app_settings.dart';
import '../../widgets/preferences_section.dart';

class VetProfileScreen extends StatefulWidget {
  const VetProfileScreen({super.key});

  @override
  State<VetProfileScreen> createState() => _VetProfileScreenState();
}

class _VetProfileScreenState extends State<VetProfileScreen> {
  late final TextEditingController _bio;
  late final TextEditingController _area;
  late final TextEditingController _credentials;
  bool _ready = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    final store = context.read<AppStore>();
    final profile = store.profileFor(store.currentUser!.id);
    _bio = TextEditingController(text: profile.bio);
    _area = TextEditingController(text: profile.serviceArea);
    _credentials = TextEditingController(text: profile.credentials);
    _ready = true;
  }

  @override
  void dispose() {
    if (_ready) {
      _bio.dispose();
      _area.dispose();
      _credentials.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final store = context.read<AppStore>();
    final s = context.read<AppSettings>().strings;
    await store.updateVetProfile(
      store.profileFor(store.currentUser!.id).copyWith(
        bio: _bio.text.trim(),
        serviceArea: _area.text.trim(),
        credentials: _credentials.text.trim(),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.profileSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final user = store.currentUser!;

    return Scaffold(
      appBar: AppBar(title: Text(s.vetProfile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(user.name, style: Theme.of(context).textTheme.titleLarge),
          Text(user.email),
          const SizedBox(height: 20),
          TextField(
            controller: _credentials,
            decoration: InputDecoration(
              labelText: s.credentials,
              hintText: s.credentialsHint,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _area,
            decoration: InputDecoration(
              labelText: s.serviceArea,
              hintText: s.serviceAreaHint,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bio,
            maxLines: 4,
            decoration: InputDecoration(labelText: s.bio),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _save, child: Text(s.saveProfile)),
          const SizedBox(height: 24),
          const PreferencesSection(),
          const SizedBox(height: 12),
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
