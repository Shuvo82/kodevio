import 'package:flutter/material.dart';

import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/app_size_theme.dart';



class UserDetailsDivider extends StatelessWidget with AppSizeTheme {
  final ColorScheme theme;
  final bool isDark;

  const UserDetailsDivider({
    super.key,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark
          ? theme.outline.withValues(alpha: 0.1)
          : AppColors.borderLight,
      indent: size.paddingMedium,
      endIndent: size.paddingMedium,
    );
  }
}