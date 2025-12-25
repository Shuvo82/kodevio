import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../../core/constant/app_size_theme.dart';
import '../../../../../core/services/theme_service.dart';
import 'common/user_details_section_title.dart';
import 'common/user_details_info_card.dart';
import 'common/user_details_info_row.dart';
import '../../../controllers/user_details_controller.dart';

class UserDetailsAddressSection extends StatelessWidget with AppSizeTheme {
  final UserDetailsController controller;

  const UserDetailsAddressSection({super.key, required this.controller});

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
          UserDetailsSectionTitle(title: 'Address', theme: theme),
          SizedBox(height: size.spacingMedium),
          UserDetailsInfoCard(
            theme: theme,
            isDark: isDark,
            children: [
              UserDetailsInfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: controller.fullAddress,
                theme: theme,
                isMultiLine: true,
              ),
            ],
          ),
        ],
      );
    });
  }
}