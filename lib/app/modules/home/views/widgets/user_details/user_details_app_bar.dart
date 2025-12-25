import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_size_theme.dart';

import '../../../controllers/user_details_controller.dart';

class UserDetailsAppBar extends StatelessWidget with AppSizeTheme {
  final UserDetailsController controller;

  const UserDetailsAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.user.value;
      if (user == null) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }

      return SliverAppBar(
        pinned: true,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          user.name ?? 'Unknown',
          style: TextStyle(
            color: AppColors.white,
            fontSize: size.textLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }
}
