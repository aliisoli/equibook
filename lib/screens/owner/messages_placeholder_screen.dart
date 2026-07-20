import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../settings/app_settings.dart';
import '../../widgets/common.dart';

class MessagesPlaceholderScreen extends StatelessWidget {
  const MessagesPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>().strings;
    return Scaffold(
      appBar: AppBar(title: Text(s.messages)),
      body: EmptyState(
        icon: Icons.chat_bubble_outline,
        title: s.messages,
        message: s.messagesComingSoon,
      ),
    );
  }
}
