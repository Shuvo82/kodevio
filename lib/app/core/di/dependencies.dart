import 'package:get/get.dart';
import '../common/widgets/ui.dart';
import '../network/api_service.dart';
import '../services/connectivity_check_service.dart';
import '../services/http_logger_service.dart';
import '../services/storage_manager_service.dart';
import '../services/theme_service.dart';
import '../utils/responsive_service.dart';

/// Service loader definition for progressive loading
class ServiceLoader {
  final String name;
  final String icon;
  final Future<void> Function() loader;

  ServiceLoader({required this.name, required this.icon, required this.loader});
}

/// Critical dependencies that must be loaded before showing UI
/// These are minimal and fast-loading services
Future<void> setupCriticalDependencies() async {
  Ui.logInfo('Setting up critical dependencies...');

  // Storage Manager - needed for persisted settings
  await Get.putAsync<StorageManagerService>(
    () async => StorageManagerService().init(),
    permanent: true,
  );

  // Theme service - needed for initial theme
  Get.put<ThemeService>(ThemeService(), permanent: true);

  // HTTP Logger - needed for API logging
  Get.put<HttpLoggerService>(HttpLoggerService(), permanent: true);

  // API Service - needed for data fetching
  Get.put<ApiService>(ApiService(), permanent: true);

  Ui.logInfo('Critical dependencies loaded');
}

/// Get list of remaining services to load progressively
/// Each service has a name, icon, and loader function
List<ServiceLoader> getRemainingServiceLoaders() {
  return [
    ServiceLoader(
      name: 'Connectivity',
      icon: '📶',
      loader: () async {
        await Get.putAsync<ConnectivityService>(
          () async => ConnectivityService().init(),
          permanent: true,
        );
      },
    ),

    ServiceLoader(
      name: 'Responsive Layout',
      icon: '📐',
      loader: () async {
        Get.put<ResponsiveService>(ResponsiveService(), permanent: true);
      },
    ),
  ];
}

/// Legacy function for backwards compatibility (loads all at once)
Future<void> setupGlobalDependencies() async {
  Ui.logInfo('Starting global dependencies...');
  await setupCriticalDependencies();

  final loaders = getRemainingServiceLoaders();
  for (final loader in loaders) {
    await loader.loader();
  }

  Ui.logInfo('All services started...');
}
