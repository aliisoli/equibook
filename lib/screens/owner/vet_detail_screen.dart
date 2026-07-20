import 'package:flutter/material.dart';

import 'provider_detail_screen.dart';

class VetDetailScreen extends StatelessWidget {
  const VetDetailScreen({super.key, required this.vetId});

  final String vetId;

  @override
  Widget build(BuildContext context) {
    return ProviderDetailScreen(providerId: vetId);
  }
}
