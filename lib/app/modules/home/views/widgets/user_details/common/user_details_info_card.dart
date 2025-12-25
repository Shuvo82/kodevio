import 'package:flutter/material.dart';


import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/app_size_theme.dart';

class UserDetailsInfoCard extends StatelessWidget with AppSizeTheme {
  final ColorScheme theme;
  final bool isDark;
  final List<Widget> children;

  const UserDetailsInfoCard({
    super.key,
    required this.theme,
    required this.isDark,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.surfaceContainerHigh : AppColors.white,
        borderRadius: BorderRadius.circular(size.radiusMedium),
        border: Border.all(
          color: isDark
              ? theme.outline.withValues(alpha: 0.2)
              : AppColors.borderLight,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: size.radiusSmall,
                  offset: Offset(0, size.spacingTiny),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }
}