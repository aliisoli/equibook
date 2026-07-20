import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../settings/app_settings.dart';
import '../../theme/app_theme.dart';
import '../../widgets/preferences_section.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>().strings;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.sand, Color(0xFFE7F0E8), AppTheme.sand],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 24),
              const PreferencesSection(),
              const SizedBox(height: 32),
              Text(
                s.appName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.forest,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                s.tagline,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.ink.withValues(alpha: 0.75),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                  child: Text(s.createAccount),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: Text(s.logIn),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                s.demoAccounts(AppStore.demoPassword),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.forest,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${s.roleOwner}: ${AppStore.demoOwnerEmail}\n${s.roleVet}: ${AppStore.demoVetEmail}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.ink.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),
              Consumer<AppStore>(
                builder: (context, store, _) {
                  return Wrap(
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => store.login(
                          email: AppStore.demoOwnerEmail,
                          password: AppStore.demoPassword,
                        ),
                        child: Text(s.tryAsOwner),
                      ),
                      TextButton(
                        onPressed: () => store.login(
                          email: AppStore.demoVetEmail,
                          password: AppStore.demoPassword,
                        ),
                        child: Text(s.tryAsVet),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
