import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/app_settings.dart';
import '../settings/preferences.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key, this.showTitle = true});

  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final s = settings.strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text(s.preferences, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
        ],
        Text(s.languageLabel, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SegmentedButton<AppLanguage>(
          segments: [
            ButtonSegment(
              value: AppLanguage.english,
              label: Text(AppLanguage.english.nativeLabel),
            ),
            ButtonSegment(
              value: AppLanguage.farsi,
              label: Text(AppLanguage.farsi.nativeLabel),
            ),
          ],
          selected: {settings.language},
          onSelectionChanged: (value) => settings.setLanguage(value.first),
        ),
        const SizedBox(height: 20),
        Text(s.calendar, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SegmentedButton<AppCalendar>(
          segments: [
            ButtonSegment(
              value: AppCalendar.gregorian,
              label: Text(
                AppCalendar.gregorian.label(settings.language),
                textAlign: TextAlign.center,
              ),
            ),
            ButtonSegment(
              value: AppCalendar.hijriShamsi,
              label: Text(
                AppCalendar.hijriShamsi.label(settings.language),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          selected: {settings.calendar},
          onSelectionChanged: (value) => settings.setCalendar(value.first),
        ),
      ],
    );
  }
}
