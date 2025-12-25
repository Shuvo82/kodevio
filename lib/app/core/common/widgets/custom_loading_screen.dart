import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_size_theme.dart';

class CustomLoadingScreen extends StatelessWidget with AppSizeTheme {
  final RxBool isLoading;

  const CustomLoadingScreen({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!isLoading.value) return const SizedBox.shrink();
      var theme= Theme.of(context).colorScheme;

      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: theme.surface),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(size.paddingLarge),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(size.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: size.radiusSmall,
                  offset: Offset(0, size.spacingTiny),
                ),
              ],
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.10),
                width: size.borderThin,
              ),
            ),
            child: SizedBox(
              height: size.sizeMedium,
              width: size.sizeMedium,
              child: SpinKitWave(
                color: AppColors.primary,
                size: size.iconLarge,
              ),
            ),
          ),
        ),
      );
    });
  }
}
