import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/widgets/custom_text_widget.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_size_theme.dart';
import '../../../../../core/services/theme_service.dart';
import '../../../controllers/home_controller.dart';

class HomeSearchSection extends StatelessWidget with AppSizeTheme {
  final HomeController controller;

  const HomeSearchSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = ThemeService.to.isDarkMode;

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.paddingMedium,
            vertical: size.paddingSmall,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? theme.surface.withValues(alpha: 0.8)
                  : AppColors.gray50,
              borderRadius: BorderRadius.circular(size.radiusMedium),
              border: Border.all(
                color: isDark ? theme.outline : AppColors.borderLight,
              ),
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.searchUsers,
              style: TextStyle(
                color: theme.tertiary,
                fontSize: size.textMedium,
              ),
              decoration: InputDecoration(
                hintText: 'Search users by name...',
                hintStyle: TextStyle(
                  color: theme.tertiary.withValues(alpha: 0.5),
                  fontSize: size.textMedium,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.tertiary.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: size.paddingMedium,
                  vertical: size.paddingMedium,
                ),
              ),
            ),
          ),
        ),

        // Users Count
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.paddingMedium,
            vertical: size.paddingSmall,
          ),
          child: Row(
            children: [
              Obx(
                () => CustomTextWidget(
                  text: controller.searchQuery.isEmpty
                      ? 'Showing ${controller.filteredUsers.length} of ${controller.users.length} users'
                      : 'Found ${controller.filteredUsers.length} users',
                  fontSize: size.textSmall,
                  fontColor: theme.tertiary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}