import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:provider/provider.dart';

import 'data/app_store.dart';
import 'models/models.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/owner/owner_shell.dart';
import 'screens/vet/vet_shell.dart';
import 'settings/app_settings.dart';
import 'theme/app_theme.dart';

class EquiBookApp extends StatelessWidget {
  const EquiBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return MaterialApp(
      title: 'EquiBook',
      debugShowCheckedModeBanner: false,
      locale: settings.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('fa'),
        Locale('fa', 'IR'),
      ],
      localizationsDelegates: const [
        PersianMaterialLocalizations.delegate,
        PersianCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightFor(settings.language),
      builder: (context, child) {
        return Directionality(
          textDirection: settings.textDirection,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const RootGate(),
    );
  }
}

class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final settings = context.watch<AppSettings>();
    if (!store.ready || !settings.ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final user = store.currentUser;
    if (user == null) return const WelcomeScreen();
    return user.role == UserRole.owner
        ? const OwnerShell()
        : const VetShell();
  }
}

extension AppContextX on BuildContext {
  AppSettings get settings => read<AppSettings>();
  AppSettings get watchSettings => watch<AppSettings>();
}
