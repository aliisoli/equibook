import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/app_settings.dart';
import 'availability_screen.dart';
import 'services_screen.dart';
import 'vet_bookings_screen.dart';
import 'vet_profile_screen.dart';

class VetShell extends StatefulWidget {
  const VetShell({super.key});

  @override
  State<VetShell> createState() => _VetShellState();
}

class _VetShellState extends State<VetShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>().strings;
    final pages = const [
      VetBookingsScreen(),
      ServicesScreen(),
      AvailabilityScreen(),
      VetProfileScreen(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.inbox_outlined),
            selectedIcon: const Icon(Icons.inbox),
            label: s.bookings,
          ),
          NavigationDestination(
            icon: const Icon(Icons.medical_services_outlined),
            selectedIcon: const Icon(Icons.medical_services),
            label: s.servicesAndRates,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: s.availability,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: s.profile,
          ),
        ],
      ),
    );
  }
}
