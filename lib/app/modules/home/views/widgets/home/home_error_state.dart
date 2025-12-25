import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/custom_text_widget.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_size_theme.dart';
import '../../../controllers/home_controller.dart';

class HomeErrorState extends StatelessWidget with AppSizeTheme {
  final HomeController controller;

  const HomeErrorState({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(size.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(size.paddingLarge),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: size.iconExtraLarge,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: size.spacingLarge),
            CustomTextWidget(
              text: 'Oops! Something went wrong',
              fontSize: size.textLarge,
              fontWeight: FontWeight.bold,
              fontColor: theme.tertiary,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.spacingSmall),
            CustomTextWidget(
              text: controller.errorMessage.value,
              fontSize: size.textSmall,
              fontColor: theme.tertiary.withValues(alpha: 0.7),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            SizedBox(height: size.spacingLarge),
            ElevatedButton.icon(
              onPressed: controller.refreshUsers,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: size.paddingLarge,
                  vertical: size.paddingMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.radiusMedium),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}