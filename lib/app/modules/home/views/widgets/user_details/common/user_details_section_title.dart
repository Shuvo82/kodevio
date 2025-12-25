import 'package:flutter/material.dart';

import '../../../../../../core/common/widgets/custom_text_widget.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/app_size_theme.dart';

class UserDetailsSectionTitle extends StatelessWidget with AppSizeTheme {
  final String title;
  final ColorScheme theme;

  const UserDetailsSectionTitle({
    super.key,
    required this.title,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: size.iconMedium,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(size.radiusTiny),
          ),
        ),
        SizedBox(width: size.spacingSmall),
        CustomTextWidget(
          text: title,
          fontSize: size.textMedium,
          fontWeight: FontWeight.bold,
          fontColor: theme.tertiary,
        ),
      ],
    );
  }
}
