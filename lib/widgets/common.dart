import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_strings.dart';
import '../models/models.dart';
import '../settings/app_settings.dart';
import '../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppTheme.moss.withValues(alpha: 0.7)),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.ink.withValues(alpha: 0.7),
              ),
            ),
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final BookingStatus status;

  Color get _color => switch (status) {
    BookingStatus.pending => AppTheme.leather,
    BookingStatus.confirmed => AppTheme.moss,
    BookingStatus.completed => AppTheme.forest,
    BookingStatus.declined => Colors.red.shade700,
    BookingStatus.cancelled => Colors.grey.shade700,
  };

  String _label(AppStrings s) => switch (status) {
    BookingStatus.pending => s.statusPending,
    BookingStatus.confirmed => s.statusConfirmed,
    BookingStatus.declined => s.statusDeclined,
    BookingStatus.completed => s.statusCompleted,
    BookingStatus.cancelled => s.statusCancelled,
  };

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>().strings;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _label(s),
        style: TextStyle(
          color: _color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class LocalImage extends StatelessWidget {
  const LocalImage({
    super.key,
    required this.path,
    this.size = 64,
    this.borderRadius = 12,
    this.fallbackIcon = Icons.image_outlined,
  });

  final String? path;
  final double size;
  final double borderRadius;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    Widget child = Icon(fallbackIcon, color: AppTheme.moss);
    if (path != null && path!.isNotEmpty) {
      if (kIsWeb || path!.startsWith('http') || path!.startsWith('blob:')) {
        child = Image.network(
          path!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return Icon(fallbackIcon, color: AppTheme.moss);
          },
        );
      } else {
        final file = File(path!);
        if (file.existsSync()) {
          child = Image.file(file, fit: BoxFit.cover);
        }
      }
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size,
        height: size,
        color: AppTheme.moss.withValues(alpha: 0.12),
        child: child,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
