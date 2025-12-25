import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/core/common/widgets/development_widgets/http_logs_screen.dart';
import 'app/core/common/widgets/movable_floating_button.dart';
import 'app/core/constant/app_colors.dart';
import 'app/core/di/dependencies.dart';
import 'app/core/services/theme_service.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  const bool isDebug = !bool.fromEnvironment('dart.vm.product');

  Get.isLogEnable = isDebug; // true for debug, false for release
  WidgetsFlutterBinding.ensureInitialized();

  await setupCriticalDependencies();

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return Obx(
          () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Kodevio",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            theme: lightThemeData,
            darkTheme: darkThemeData,
            themeMode: Get.find<ThemeService>().materialThemeMode,

            builder: (context, child) {
              const bool isDebug = !bool.fromEnvironment('dart.vm.product');
              return Stack(
                children: [
                  child ?? const SizedBox.shrink(),
                  if (isDebug)
                    MovableFloatingButton(
                      icon: Icons.bug_report,
                      color: AppColors.primary,
                      onTap: () {
                        Get.to(
                          () => const HttpLogsScreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
                    ),
                  if (isDebug)
                    MovableFloatingButton(
                      onTap: () {
                        ThemeService.to.toggleTheme();
                      },
                      icon: ThemeService.to.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: ThemeService.to.isDarkMode
                          ? AppColors.primary
                          : AppColors.primary,
                    ),
                ],
              );
            },
          ),
        );
      },
    ),
  );
}
