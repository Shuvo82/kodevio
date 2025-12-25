import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../core/common/widgets/custom_text_widget.dart';
import '../../../../../core/common/widgets/custom_animations.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_size_theme.dart';
import '../../../../../core/services/theme_service.dart';
import '../../../../../routes/app_pages.dart';
import '../../../controllers/home_controller.dart';
import '../../../models/users_res_model.dart';

class HomeListSection extends StatelessWidget with AppSizeTheme {
  final HomeController controller;

  const HomeListSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = ThemeService.to.isDarkMode;

    return Obx(() {
      if (controller.filteredUsers.isEmpty) {
        return _buildEmptyState(theme);
      }

      return RefreshIndicator(
        onRefresh: controller.refreshUsers,
        color: AppColors.primary,
        child: ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: size.paddingMedium),
          itemCount:
              controller.filteredUsers.length +
              (controller.hasMoreData.value && controller.searchQuery.isEmpty
                  ? 1
                  : 0),
          itemBuilder: (context, index) {
            if (index >= controller.filteredUsers.length) {
              return _buildLoadMoreIndicator();
            }

            final user = controller.filteredUsers[index];
            return _buildUserCard(context, user, theme, isDark, index);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(ColorScheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: size.iconExtraLarge,
            color: theme.tertiary.withValues(alpha: 0.3),
          ),
          SizedBox(height: size.spacingMedium),
          CustomTextWidget(
            text: 'No users found',
            fontSize: size.textLarge,
            fontColor: theme.tertiary.withValues(alpha: 0.5),
          ),
          SizedBox(height: size.spacingSmall),
          CustomTextWidget(
            text: 'Try a different search term',
            fontSize: size.textSmall,
            fontColor: theme.tertiary.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return Padding(
          padding: EdgeInsets.all(size.paddingLarge),
          child: Center(
            child: SpinKitThreeBounce(
              color: AppColors.primary,
              size: size.iconMedium,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildUserCard(
    BuildContext context,
    UsersResModel user,
    ColorScheme theme,
    bool isDark,
    int index,
  ) {
    return ShowUpAnimation(
      delay: Duration(milliseconds: index * 100),
      child: Container(
        margin: EdgeInsets.only(bottom: size.spacingMedium),
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
        child: GestureDetector(
          onTap: () => Get.toNamed(Routes.USERDETAILS, arguments: user),
          child: Container(
            margin: EdgeInsets.all(size.paddingMedium),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.radiusMedium),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: size.sizeMedium,
                  height: size.sizeMedium,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(size.radiusMedium),
                  ),
                  child: Center(
                    child: CustomTextWidget(
                      text: (user.name?.isNotEmpty ?? false)
                          ? user.name![0].toUpperCase()
                          : '?',
                      fontSize: size.textLarge,
                      fontWeight: FontWeight.bold,
                      fontColor: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(width: size.spacingMedium),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: user.name ?? 'Unknown',
                        fontSize: size.textMedium,
                        fontWeight: FontWeight.w600,
                        fontColor: theme.tertiary,
                        maxLines: 1,
                      ),
                      SizedBox(height: size.spacingTiny),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: size.iconSmall,
                            color: theme.tertiary.withValues(alpha: 0.6),
                          ),
                          SizedBox(width: size.spacingTiny),
                          Expanded(
                            child: CustomTextWidget(
                              text: user.email ?? 'No email',
                              fontSize: size.textSmall,
                              fontColor: theme.tertiary.withValues(alpha: 0.7),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.spacingTiny),
                      Row(
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: size.iconSmall,
                            color: AppColors.primary.withValues(alpha: 0.8),
                          ),
                          SizedBox(width: size.spacingTiny),
                          Expanded(
                            child: CustomTextWidget(
                              text: user.company?.name ?? 'No company',
                              fontSize: size.textSmall,
                              fontColor: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                Container(
                  padding: EdgeInsets.all(size.paddingSmall),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: size.iconSmall,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
