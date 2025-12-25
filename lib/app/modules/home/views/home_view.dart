import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'widgets/home/home_app_bar.dart';
import 'widgets/home/home_drawer.dart';
import 'widgets/home/home_error_state.dart';
import 'widgets/home/home_list_section.dart';
import 'widgets/home/home_loading_state.dart';
import 'widgets/home/home_search_section.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: HomeAppBar(controller: controller),
      drawer: const HomeDrawer(),
      body: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const HomeLoadingState();
        }

        if (controller.hasError.value && controller.users.isEmpty) {
          return HomeErrorState(controller: controller);
        }

        return Column(
          children: [
            HomeSearchSection(controller: controller),
            Expanded(child: HomeListSection(controller: controller)),
          ],
        );
      }),
    );
  }
}
