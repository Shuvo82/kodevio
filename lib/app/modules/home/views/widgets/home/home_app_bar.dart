import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../../core/common/widgets/custom_text_widget.dart';
import '../../../../../core/constant/app_size_theme.dart';
import '../../../controllers/home_controller.dart';

class HomeAppBar extends StatelessWidget with AppSizeTheme implements PreferredSizeWidget {
  final HomeController controller;

  const HomeAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: theme.surface,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu_rounded, color: theme.tertiary),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: CustomTextWidget(
        text: 'Users',
        fontSize: size.textLarge,
        fontWeight: FontWeight.bold,
        fontColor: theme.tertiary,
      ),
      centerTitle: true,
      actions: [
        Obx(
          () => controller.searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: theme.tertiary),
                  onPressed: controller.clearSearch,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}