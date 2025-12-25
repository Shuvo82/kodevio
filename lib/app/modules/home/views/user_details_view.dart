import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/custom_text_widget.dart';
import '../../../core/common/widgets/custom_animations.dart';
import '../../../core/constant/app_size_theme.dart';
import '../controllers/user_details_controller.dart';
import 'widgets/user_details/user_details_address_section.dart';
import 'widgets/user_details/user_details_app_bar.dart';
import 'widgets/user_details/user_details_company_section.dart';
import 'widgets/user_details/user_details_contact_section.dart';

class UserDetailsView extends GetView<UserDetailsController> with AppSizeTheme {
  const UserDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          return Center(
            child: CustomTextWidget(
              text: 'User not found',
              fontSize: size.textLarge,
              fontColor: theme.tertiary,
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            UserDetailsAppBar(controller: controller),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(size.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowUpAnimation(
                      delay: const Duration(milliseconds: 0),
                      child: UserDetailsContactSection(controller: controller),
                    ),
                    SizedBox(height: size.spacingLarge),
                    ShowUpAnimation(
                      delay: const Duration(milliseconds: 200),
                      child: UserDetailsAddressSection(controller: controller),
                    ),
                    SizedBox(height: size.spacingLarge),
                    ShowUpAnimation(
                      delay: const Duration(milliseconds: 400),
                      child: UserDetailsCompanySection(controller: controller),
                    ),
                    SizedBox(height: size.spacingExtraLarge),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
