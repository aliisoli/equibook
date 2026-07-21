import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/app_settings.dart';
import '../../theme/mock_ui.dart';
import '../../widgets/preferences_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>().strings;

    return Scaffold(
      backgroundColor: MockColors.pageBg,
      appBar: AppBar(
        title: Text(s.settings),
        backgroundColor: MockColors.pageBg,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: PreferencesSection(showTitle: false),
            ),
          ),
        ],
      ),
    );
  }
}
