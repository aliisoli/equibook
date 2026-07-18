import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/app_store.dart';
import 'models/models.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/owner/owner_shell.dart';
import 'screens/vet/vet_shell.dart';
import 'theme/app_theme.dart';

class EquiBookApp extends StatelessWidget {
  const EquiBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EquiBook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RootGate(),
    );
  }
}

class RootGate extends StatelessWidget {
  const RootGate({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    if (!store.ready) {
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
