import 'package:flutter/material.dart';

import '../../models/models.dart';
import 'find_providers_screen.dart';

/// Kept for older navigation call sites.
class FindVetsScreen extends StatelessWidget {
  const FindVetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FindProvidersScreen(category: ServiceCategory.veterinary);
  }
}
