import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../settings/app_settings.dart';
import '../../theme/mock_ui.dart';
import '../../widgets/common.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.category});

  final ServiceCategory category;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>().strings;
    return Scaffold(
      appBar: AppBar(title: Text(s.categoryTitle(category))),
      body: EmptyState(
        icon: categoryIcon(category),
        title: s.comingSoon,
        message: s.comingSoonMessage,
      ),
    );
  }
}
