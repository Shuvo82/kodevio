import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../../core/constant/app_size_theme.dart';
import '../../../../../core/services/theme_service.dart';
import 'common/user_details_section_title.dart';
import 'common/user_details_info_card.dart';
import 'common/user_details_info_row.dart';
import 'common/user_details_divider.dart';
import '../../../controllers/user_details_controller.dart';

class UserDetailsContactSection extends StatelessWidget with AppSizeTheme {
  final UserDetailsController controller;

  const UserDetailsContactSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = ThemeService.to.isDarkMode;

    return Obx(() {
      final user = controller.user.value;
      if (user == null) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserDetailsSectionTitle(title: 'Contact Information', theme: theme),
          SizedBox(height: size.spacingMedium),
          UserDetailsInfoCard(
            theme: theme,
            isDark: isDark,
            children: [
              UserDetailsInfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: user.email ?? 'N/A',
                theme: theme,
              ),
              UserDetailsDivider(theme: theme, isDark: isDark),
              UserDetailsInfoRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: user.phone ?? 'N/A',
                theme: theme,
              ),
              UserDetailsDivider(theme: theme, isDark: isDark),
              UserDetailsInfoRow(
                icon: Icons.language_outlined,
                label: 'Website',
                value: user.website ?? 'N/A',
                theme: theme,
                isLink: true,
              ),
            ],
          ),
        ],
      );
    });
  }
}