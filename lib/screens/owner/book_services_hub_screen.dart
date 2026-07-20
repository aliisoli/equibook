import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../settings/app_settings.dart';
import '../../theme/app_theme.dart';
import '../../theme/mock_ui.dart';
import 'coming_soon_screen.dart';
import 'find_providers_screen.dart';

class BookServicesHubScreen extends StatelessWidget {
  const BookServicesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>().strings;
    const categories = [
      ServiceCategory.veterinary,
      ServiceCategory.farriery,
      ServiceCategory.ridingClass,
      ServiceCategory.clubManagement,
      ServiceCategory.shop,
    ];

    return Scaffold(
      backgroundColor: MockColors.pageBg,
      appBar: AppBar(
        title: Text(s.bookServices),
        backgroundColor: MockColors.pageBg,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                if (category.isBookable) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FindProvidersScreen(category: category),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: categoryTileBg(category),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        categoryIcon(category),
                        color: categoryTileIcon(category),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.categoryTitle(category),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category.isBookable
                                ? s.categorySubtitle(category)
                                : s.comingSoon,
                            style: TextStyle(
                              color: AppTheme.ink.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
