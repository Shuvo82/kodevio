import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_size_theme.dart';
import 'custom_text_widget.dart';

class Ui with AppSizeTheme {
  static void successSnackBar({
    String title = 'Success',
    required String message,
  }) {
    final uiInstance = Ui();
    Get.log("Log from Snackbar[$title] $message");
    Get.showSnackbar(
      GetSnackBar(
        titleText: CustomTextWidget(
          text: title,
          fontColor: AppColors.white,
          fontSize: uiInstance.size.textSmall,
          fontWeight: FontWeight.w600,
        ),
        messageText: CustomTextWidget(
          text: message,
          fontColor: AppColors.white,
          fontSize: uiInstance.size.textXSmall,
          fontWeight: FontWeight.w400,
        ),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.fromLTRB(
          uiInstance.size.paddingMedium,
          uiInstance.size.spacingExtraLarge,
          uiInstance.size.paddingMedium,
          uiInstance.size.paddingMedium,
        ),
        backgroundColor: AppColors.success,
        boxShadows: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: uiInstance.size.radiusSmall,
            offset: Offset(0, uiInstance.size.spacingTiny),
          ),
        ],
        icon: Container(
          padding: EdgeInsets.all(uiInstance.size.paddingTiny),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(uiInstance.size.iconMedium),
          ),
          child: Icon(
            Icons.check_circle,
            size: uiInstance.size.iconMedium,
            color: AppColors.white,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: uiInstance.size.paddingMedium,
          vertical: uiInstance.size.spacingSmall,
        ),
        borderRadius: uiInstance.size.radiusMedium,
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  static void infoSnackBar({
    String title = 'Info',
    required String message,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
  }) {
    final uiInstance = Ui();
    Get.showSnackbar(
      GetSnackBar(
        titleText: CustomTextWidget(
          text: title,
          fontColor: AppColors.white,
          fontSize: uiInstance.size.textSmall,
          fontWeight: FontWeight.w600,
        ),
        messageText: CustomTextWidget(
          text: message,
          fontColor: AppColors.white,
          fontSize: uiInstance.size.textXSmall,
          fontWeight: FontWeight.w400,
        ),
        snackPosition: snackPosition,
        margin: EdgeInsets.fromLTRB(
          uiInstance.size.paddingMedium,
          uiInstance.size.spacingExtraLarge,
          uiInstance.size.paddingMedium,
          uiInstance.size.spacingExtraLarge,
        ),
        backgroundColor: AppColors.info,
        boxShadows: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.3),
            blurRadius: uiInstance.size.radiusSmall,
            offset: Offset(0, uiInstance.size.spacingTiny),
          ),
        ],
        icon: Container(
          padding: EdgeInsets.all(uiInstance.size.paddingTiny),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(uiInstance.size.iconMedium),
          ),
          child: Icon(
            Icons.info,
            size: uiInstance.size.iconMedium,
            color: AppColors.white,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: uiInstance.size.paddingMedium,
          vertical: uiInstance.size.spacingSmall,
        ),
        borderRadius: uiInstance.size.radiusMedium,
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  static void errorSnackBar({
    String title = 'Error',
    required String message,
  }) {
    final uiInstance = Ui();
    final translatedTitle = title.tr;
    Get.log("[$translatedTitle] $message", isError: true);
    Get.showSnackbar(
      GetSnackBar(
        titleText: CustomTextWidget(
          text: translatedTitle,
          fontColor: AppColors.white,
          fontSize: uiInstance.size.textSmall,
          fontWeight: FontWeight.w600,
        ),
        messageText: CustomTextWidget(
          text: message,
          fontColor: AppColors.white,
          fontSize: uiInstance.size.textXSmall,
          fontWeight: FontWeight.w400,
        ),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.fromLTRB(
          uiInstance.size.paddingMedium,
          uiInstance.size.spacingExtraLarge,
          uiInstance.size.paddingMedium,
          uiInstance.size.paddingMedium,
        ),
        backgroundColor: AppColors.error,
        boxShadows: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.3),
            blurRadius: uiInstance.size.radiusSmall,
            offset: Offset(0, uiInstance.size.spacingTiny),
          ),
        ],
        icon: Container(
          padding: EdgeInsets.all(uiInstance.size.paddingTiny),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(uiInstance.size.iconMedium),
          ),
          child: Icon(
            Icons.error,
            size: uiInstance.size.iconMedium,
            color: AppColors.white,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: uiInstance.size.paddingMedium,
          vertical: uiInstance.size.spacingSmall,
        ),
        borderRadius: uiInstance.size.radiusMedium,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void notificationSnackBar({
    String title = 'Notification',
    required String message,
  }) {
    final uiInstance = Ui();
    Get.log("[$title] $message", isError: false);
    Get.showSnackbar(
      GetSnackBar(
        titleText: CustomTextWidget(
          text: title,
          fontColor: AppColors.white,
          fontSize: uiInstance.size.textMedium,
          fontWeight: FontWeight.w600,
        ),
        messageText: CustomTextWidget(
          text: message,
          fontColor: AppColors.white,
          fontSize: uiInstance.size.textSmall,
          fontWeight: FontWeight.w400,
        ),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(uiInstance.size.paddingMedium),
        backgroundColor: AppColors.primary,
        borderColor: AppColors.secondary.withValues(alpha: 0.3),
        borderWidth: uiInstance.size.borderWidth,
        boxShadows: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: uiInstance.size.radiusMedium,
            offset: Offset(0, uiInstance.size.spacingTiny),
          ),
        ],
        icon: Container(
          padding: EdgeInsets.all(uiInstance.size.paddingTiny),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(uiInstance.size.iconLarge),
          ),
          child: Icon(
            Icons.notifications_active,
            size: uiInstance.size.iconLarge,
            color: AppColors.white,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: uiInstance.size.paddingMedium,
          vertical: uiInstance.size.spacingMedium,
        ),
        borderRadius: uiInstance.size.radiusMedium,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void warningSnackBar({
    String title = 'Warning',
    required String message,
  }) {
    final uiInstance = Ui();
    Get.log("[$title] $message", isError: false);
    Get.showSnackbar(
      GetSnackBar(
        titleText: CustomTextWidget(
          text: title,
          fontColor: AppColors.black,
          fontSize: uiInstance.size.textSmall,
          fontWeight: FontWeight.w600,
          maxLines: 2,
        ),
        messageText: CustomTextWidget(
          text: message,
          fontColor: AppColors.black,
          fontSize: uiInstance.size.textXSmall,
          fontWeight: FontWeight.w400,
        ),
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.fromLTRB(
          uiInstance.size.paddingMedium,
          uiInstance.size.spacingExtraLarge,
          uiInstance.size.paddingMedium,
          uiInstance.size.paddingMedium,
        ),
        backgroundColor: AppColors.warning,
        boxShadows: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.3),
            blurRadius: uiInstance.size.radiusSmall,
            offset: Offset(0, uiInstance.size.spacingTiny),
          ),
        ],
        icon: Container(
          padding: EdgeInsets.all(uiInstance.size.paddingTiny),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(uiInstance.size.iconMedium),
          ),
          child: Icon(
            Icons.warning,
            size: uiInstance.size.iconMedium,
            color: AppColors.black,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: uiInstance.size.paddingMedium,
          vertical: uiInstance.size.spacingSmall,
        ),
        borderRadius: uiInstance.size.radiusMedium,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ==================== Logging Methods ====================

  /// Logs a success message with green circle indicator
  static void logSuccess(String message) {
    Get.log('🟢 $message');
  }

  /// Logs an error message with red circle indicator
  static void logError(String message) {
    Get.log('🔴 $message', isError: true);
  }

  /// Logs a warning message with yellow circle indicator
  static void logWarning(String message) {
    Get.log('🟡 $message');
  }

  /// Logs an info message with blue circle indicator
  static void logInfo(String message) {
    Get.log('🔵 $message');
  }


}
