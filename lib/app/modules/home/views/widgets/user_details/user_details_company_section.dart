import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constant/app_size_theme.dart';
import '../../../../../core/services/theme_service.dart';
import 'common/user_details_section_title.dart';
import 'common/user_details_info_card.dart';
import 'common/user_details_info_row.dart';
import 'common/user_details_divider.dart';
import '../../../controllers/user_details_controller.dart';

class UserDetailsCompanySection extends StatelessWidget with AppSizeTheme {
  final UserDetailsController controller;

  const UserDetailsCompanySection({super.key, required this.controller});

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
          UserDetailsSectionTitle(title: 'Company', theme: theme),
          SizedBox(height: size.spacingMedium),
          UserDetailsInfoCard(
            theme: theme,
            isDark: isDark,
            children: [
              UserDetailsInfoRow(
                icon: Icons.business_outlined,
                label: 'Company',
                value: user.company?.name ?? 'N/A',
                theme: theme,
              ),
              UserDetailsDivider(theme: theme, isDark: isDark),
              UserDetailsInfoRow(
                icon: Icons.format_quote_outlined,
                label: 'Catch Phrase',
                value: user.company?.catchPhrase ?? 'N/A',
                theme: theme,
                isMultiLine: true,
              ),
              UserDetailsDivider(theme: theme, isDark: isDark),
              UserDetailsInfoRow(
                icon: Icons.work_outline_rounded,
                label: 'Business',
                value: user.company?.bs ?? 'N/A',
                theme: theme,
              ),
            ],
          ),
        ],
      );
    });
  }
}