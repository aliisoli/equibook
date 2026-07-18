import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  'EquiBook',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppTheme.forest,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Book trusted equine vets for your horses — rates upfront, cash offline.',
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
                    child: const Text('Create account'),
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
                    child: const Text('Log in'),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Demo accounts (password: ${AppStore.demoPassword})',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.forest,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Owner: ${AppStore.demoOwnerEmail}\nVet: ${AppStore.demoVetEmail}',
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
                          child: const Text('Try as owner'),
                        ),
                        TextButton(
                          onPressed: () => store.login(
                            email: AppStore.demoVetEmail,
                            password: AppStore.demoPassword,
                          ),
                          child: const Text('Try as vet'),
                        ),
                      ],
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
