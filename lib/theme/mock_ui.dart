import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../models/enums.dart';
import '../../theme/app_theme.dart';

class MockColors {
  static const pageBg = Color(0xFFF5F6F8);
  static const card = Colors.white;
  static const vet = Color(0xFFE8E0F5);
  static const vetIcon = Color(0xFF7B5EA7);
  static const farrier = Color(0xFFDFF3E6);
  static const farrierIcon = Color(0xFF3E8F5A);
  static const riding = Color(0xFFFFF0D6);
  static const ridingIcon = Color(0xFFC48A1A);
  static const club = Color(0xFFDCEAF8);
  static const clubIcon = Color(0xFF3B7CB8);
  static const shop = Color(0xFFFADFDF);
  static const shopIcon = Color(0xFFC45B5B);
  static const reminderGreen = Color(0xFFE5F6EA);
  static const reminderYellow = Color(0xFFFFF6DF);
  static const reminderPink = Color(0xFFFDE8EC);
  static const heroMint = Color(0xFFE8F3EC);
}

Color categoryTileBg(ServiceCategory category) => switch (category) {
  ServiceCategory.veterinary => MockColors.vet,
  ServiceCategory.farriery => MockColors.farrier,
  ServiceCategory.ridingClass => MockColors.riding,
  ServiceCategory.clubManagement => MockColors.club,
  ServiceCategory.shop => MockColors.shop,
};

Color categoryTileIcon(ServiceCategory category) => switch (category) {
  ServiceCategory.veterinary => MockColors.vetIcon,
  ServiceCategory.farriery => MockColors.farrierIcon,
  ServiceCategory.ridingClass => MockColors.ridingIcon,
  ServiceCategory.clubManagement => MockColors.clubIcon,
  ServiceCategory.shop => MockColors.shopIcon,
};

IconData categoryIcon(ServiceCategory category) => switch (category) {
  ServiceCategory.veterinary => Icons.medical_services_outlined,
  ServiceCategory.farriery => Icons.hardware_outlined,
  ServiceCategory.ridingClass => Icons.sports_outlined,
  ServiceCategory.clubManagement => Icons.home_work_outlined,
  ServiceCategory.shop => Icons.shopping_bag_outlined,
};

IconData reminderIcon(ReminderKind kind) => switch (kind) {
  ReminderKind.vaccine => Icons.vaccines_outlined,
  ReminderKind.deworming => Icons.medication_outlined,
  ReminderKind.pregnancyTest => Icons.calendar_month_outlined,
  ReminderKind.other => Icons.notifications_outlined,
};

Color reminderBg(ReminderKind kind) => switch (kind) {
  ReminderKind.vaccine => MockColors.reminderPink,
  ReminderKind.deworming => MockColors.reminderYellow,
  ReminderKind.pregnancyTest => MockColors.reminderGreen,
  ReminderKind.other => MockColors.club,
};

String bookingStatusLabel(AppStrings s, BookingStatus status) =>
    switch (status) {
      BookingStatus.pending => s.statusPendingConfirm,
      BookingStatus.confirmed => s.statusConfirmed,
      BookingStatus.declined => s.statusDeclined,
      BookingStatus.completed => s.statusCompleted,
      BookingStatus.cancelled => s.statusCancelled,
    };

Color bookingStatusColor(BookingStatus status) => switch (status) {
  BookingStatus.pending => const Color(0xFFE8A317),
  BookingStatus.confirmed => AppTheme.moss,
  BookingStatus.completed => AppTheme.forest,
  BookingStatus.declined => Colors.red.shade700,
  BookingStatus.cancelled => Colors.grey.shade600,
};
