import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/widgets/custom_text_widget.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_size_theme.dart';
import '../../../../../core/services/theme_service.dart';

class HomeDrawer extends StatelessWidget with AppSizeTheme {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: theme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header
            Obx(
              () => Container(
                width: double.infinity,
                padding: EdgeInsets.all(size.paddingLarge),
                decoration: BoxDecoration(
                  color: ThemeService.to.isDarkMode
                      ? AppColors.surfaceDark
                      : AppColors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(size.paddingMedium),
                      decoration: BoxDecoration(
                        color: ThemeService.to.isDarkMode
                            ? AppColors.white.withValues(alpha: 0.2)
                            : AppColors.black.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: size.iconExtraLarge,
                        color: ThemeService.to.isDarkMode
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ),
                    SizedBox(height: size.spacingMedium),
                    CustomTextWidget(
                      text: 'Md. Sohorafuzzaman Shuvo',
                      fontSize: size.textMedium,
                      fontWeight: FontWeight.bold,
                      fontColor: ThemeService.to.isDarkMode
                          ? AppColors.white
                          : AppColors.black,
                    ),
                    SizedBox(height: size.spacingTiny),
                    CustomTextWidget(
                      text: 'Manage your settings',
                      fontSize: size.textXSmall,
                      fontWeight: FontWeight.w400,
                      fontColor: ThemeService.to.isDarkMode
                          ? AppColors.white.withValues(alpha: 0.8)
                          : AppColors.black.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(),

            // Theme Toggle
            Obx(
              () => _buildDrawerItem(
                context: context,
                theme: theme,
                icon: ThemeService.to.isDarkMode
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                title: 'Dark Mode',
                trailing: Transform.scale(
                  scale: 0.8,
                  child: Switch.adaptive(
                    value: ThemeService.to.isDarkMode,
                    activeThumbColor: AppColors.primary,
                    onChanged: (_) => ThemeService.to.toggleTheme(),
                  ),
                ),
                onTap: () => ThemeService.to.toggleTheme(),
              ),
            ),

            // About
            _buildDrawerItem(
              context: context,
              theme: theme,
              icon: Icons.info_outline_rounded,
              title: 'About',
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context, theme);
              },
            ),

            const Spacer(),

            // App Version
            Padding(
              padding: EdgeInsets.all(size.paddingLarge),
              child: CustomTextWidget(
                text: 'Version 1.0.0',
                fontSize: size.textXSmall,
                fontColor: theme.tertiary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );  
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required ColorScheme theme,
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(size.paddingTiny),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(size.radiusSmall),
        ),
        child: Icon(icon, color: AppColors.primary, size: size.iconSmall),
      ),
      title: CustomTextWidget(
        text: title,
        fontSize: size.textSmall,
        fontColor: theme.tertiary,
        fontWeight: FontWeight.w500,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context, ColorScheme theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.radiusLarge),
        ),
        title: CustomTextWidget(
          text: 'User Directory App',
          fontSize: size.textLarge,
          fontWeight: FontWeight.bold,
          fontColor: theme.tertiary,
        ),
        content: CustomTextWidget(
          text:
              'A simple app to display users from JSONPlaceholder API with search, pagination, and dark mode support.',
          fontSize: size.textSmall,
          fontColor: theme.tertiary,
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomTextWidget(
              text: 'Close',
              fontSize: size.textMedium,
              fontColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
