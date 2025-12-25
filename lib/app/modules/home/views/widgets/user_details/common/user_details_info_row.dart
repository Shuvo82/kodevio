import 'package:flutter/material.dart';


import '../../../../../../core/common/widgets/custom_text_widget.dart';
import '../../../../../../core/constant/app_colors.dart';
import '../../../../../../core/constant/app_size_theme.dart';

class UserDetailsInfoRow extends StatelessWidget with AppSizeTheme {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme theme;
  final bool isLink;
  final bool isMultiLine;

  const UserDetailsInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    this.isLink = false,
    this.isMultiLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size.paddingMedium),
      child: Row(
        crossAxisAlignment: isMultiLine
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(size.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(size.radiusSmall),
            ),
            child: Icon(icon, size: size.iconMedium, color: AppColors.primary),
          ),
          SizedBox(width: size.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: label,
                  fontSize: size.textXSmall,
                  fontColor: theme.tertiary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: size.spacingTiny),
                CustomTextWidget(
                  text: value,
                  fontSize: size.textSmall,
                  fontColor: isLink ? AppColors.primary : theme.tertiary,
                  fontWeight: isLink ? FontWeight.w600 : FontWeight.w500,
                  maxLines: isMultiLine ? 3 : 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}