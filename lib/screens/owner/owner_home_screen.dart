import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/app_store.dart';
import '../../models/models.dart';
import '../../settings/app_settings.dart';
import '../../theme/app_theme.dart';
import '../../theme/mock_ui.dart';
import '../../utils/app_dates.dart';
import '../../widgets/common.dart';
import 'coming_soon_screen.dart';
import 'find_providers_screen.dart';
import 'owner_bookings_screen.dart';
import 'reminders_screen.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final settings = context.watch<AppSettings>();
    final s = settings.strings;
    final dates = AppDates.watch(context);
    final user = store.currentUser!;
    final horses = store.horsesFor(user.id);
    final upcoming = store.upcomingBookingsForOwner(user.id).take(3).toList();
    final reminderItems = store.remindersForOwner(user.id).take(5).toList();
    final heroHorse = horses.isEmpty ? null : horses.first;

    return Scaffold(
      backgroundColor: MockColors.pageBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: _HomeHeader(
                  cityLabel: s.cityLabel(settings.city),
                  onCityTap: () => _pickCity(context),
                  onBellTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(s.noNotifications)),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _HeroCard(
                  greeting: s.helloName(user.name.split(' ').first),
                  welcome: s.welcomeHome,
                  dateLabel: dates.formatDate(DateTime.now()),
                  horse: heroHorse,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
                child: _ServiceGrid(
                  onTap: (category) {
                    if (category.isBookable) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              FindProvidersScreen(category: category),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ComingSoonScreen(category: category),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: _SectionTitle(
                  title: s.upcomingAppointments,
                  actionLabel: s.viewAll,
                  onAction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            OwnerBookingsScreen(ownerId: user.id),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (upcoming.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    s.noUpcoming,
                    style: TextStyle(color: AppTheme.ink.withValues(alpha: 0.6)),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final booking = upcoming[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      child: _BookingCard(booking: booking),
                    );
                  },
                  childCount: upcoming.length,
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: _SectionTitle(
                  title: s.reminders,
                  actionLabel: s.viewAll,
                  onAction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RemindersScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 132,
                child: reminderItems.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            s.noReminders,
                            style: TextStyle(
                              color: AppTheme.ink.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: reminderItems.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return _ReminderCard(reminder: reminderItems[index]);
                        },
                      ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCity(BuildContext context) async {
    final settings = context.read<AppSettings>();
    final s = settings.strings;
    final chosen = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  s.chooseCity,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...AppSettings.defaultCities.map(
                (city) => ListTile(
                  title: Text(s.cityLabel(city)),
                  trailing: city == settings.city
                      ? const Icon(Icons.check, color: AppTheme.forest)
                      : null,
                  onTap: () => Navigator.pop(context, city),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (chosen != null) await settings.setCity(chosen);
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.cityLabel,
    required this.onCityTap,
    required this.onBellTap,
  });

  final String cityLabel;
  final VoidCallback onCityTap;
  final VoidCallback onBellTap;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>().strings;
    return Row(
      children: [
        InkWell(
          onTap: onCityTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: AppTheme.forest, size: 20),
                const SizedBox(width: 4),
                Text(
                  cityLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.forest,
                  ),
                ),
                const Icon(Icons.expand_more, color: AppTheme.forest, size: 18),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                s.appName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.forest,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                s.taglineShort,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.ink.withValues(alpha: 0.55),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onBellTap,
          icon: Badge(
            isLabelVisible: false,
            child: Icon(
              Icons.notifications_none_rounded,
              color: AppTheme.forest.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.greeting,
    required this.welcome,
    required this.dateLabel,
    required this.horse,
  });

  final String greeting;
  final String welcome;
  final String dateLabel;
  final Horse? horse;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MockColors.heroMint,
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.forest,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      welcome,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.ink.withValues(alpha: 0.7),
                        height: 1.35,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: AppTheme.forest.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            dateLabel,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: AppTheme.forest,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 150,
                child: horse?.photoPath != null
                    ? LocalImage(
                        path: horse!.photoPath,
                        size: 150,
                        borderRadius: 0,
                        fallbackIcon: Icons.pets,
                      )
                    : Container(
                        color: const Color(0xFFD7E8DC),
                        child: const Icon(
                          Icons.pets,
                          size: 56,
                          color: AppTheme.moss,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid({required this.onTap});

  final ValueChanged<ServiceCategory> onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>().strings;
    // Mock order (RTL-first visual): vet, farrier, riding, club, shop
    const categories = [
      ServiceCategory.veterinary,
      ServiceCategory.farriery,
      ServiceCategory.ridingClass,
      ServiceCategory.clubManagement,
      ServiceCategory.shop,
    ];

    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () => onTap(category),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 86,
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
              decoration: BoxDecoration(
                color: categoryTileBg(category),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Icon(
                    categoryIcon(category),
                    color: categoryTileIcon(category),
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.categoryTitle(category),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    category.isBookable
                        ? s.bookAppointment
                        : s.comingSoon,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      color: AppTheme.ink.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final dates = AppDates.watch(context);
    final service = store.serviceById(booking.serviceId);
    final horse = store.horseById(booking.horseId);
    final provider = store.userById(booking.vetId);
    final category = service?.category ?? ServiceCategory.veterinary;
    final statusColor = bookingStatusColor(booking.status);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: categoryTileBg(category),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              categoryIcon(category),
              color: categoryTileIcon(category),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.localizedContentTitle(service?.title ?? s.visit),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (horse != null) horse.name,
                    if (provider != null) provider.name,
                  ].join(' · '),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.ink.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${dates.formatDate(booking.start)} · ${dates.formatTime(booking.start)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.ink.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              bookingStatusLabel(s, booking.status),
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({required this.reminder});

  final HorseReminder reminder;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final s = context.watch<AppSettings>().strings;
    final horse = store.horseById(reminder.horseId);
    final days = reminder.dueDate
        .difference(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
        )
        .inDays;

    final title = s.localizedContentTitle(reminder.title);
    return Container(
      width: 168,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: reminderBg(reminder.kind),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(reminderIcon(reminder.kind), size: 22, color: AppTheme.forest),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              horse == null ? title : '$title · ${horse.name}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                height: 1.25,
              ),
            ),
          ),
          Text(
            s.daysLeft(days),
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.ink.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}
