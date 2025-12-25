import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Handles device type detection, breakpoints, and responsive value selection
///
/// Usage:
/// ```dart
/// final responsive = Get.find<ResponsiveService>();
/// if (responsive.isMobile) { ... }
///
/// // Or use context extension:
/// if (context.isMobile) { ... }
///
/// // Get responsive values:
/// int columns = responsive.getResponsiveValue(
///   mobile: 1,
///   tablet: 2,
///   desktop: 3,
/// );
/// ```
class ResponsiveService extends GetxController {
  // Screen width breakpoints (single source of truth)
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  // Reactive values
  final _isMobile = true.obs;
  final _isTablet = false.obs;
  final _isDesktop = false.obs;
  final _isLandscape = false.obs;
  final _screenWidth = 0.0.obs;
  final _screenHeight = 0.0.obs;

  // Getters
  bool get isMobile => _isMobile.value;
  bool get isTablet => _isTablet.value;
  bool get isDesktop => _isDesktop.value;
  bool get isLandscape => _isLandscape.value;
  double get screenWidth => _screenWidth.value;
  double get screenHeight => _screenHeight.value;

  @override
  void onInit() {
    super.onInit();
    _updateScreenInfo();
  }

  void _updateScreenInfo() {
    final context = Get.context;
    if (context == null) return;

    final size = MediaQuery.of(context).size;
    _screenWidth.value = size.width;
    _screenHeight.value = size.height;

    // Update device type based on breakpoints
    if (size.width < mobileBreakpoint) {
      _isMobile.value = true;
      _isTablet.value = false;
      _isDesktop.value = false;
    } else if (size.width < tabletBreakpoint) {
      _isMobile.value = false;
      _isTablet.value = true;
      _isDesktop.value = false;
    } else {
      _isMobile.value = false;
      _isTablet.value = false;
      _isDesktop.value = true;
    }

    // Update orientation
    _isLandscape.value = size.width > size.height;
  }

  /// Call this when screen size changes (e.g., rotation, window resize)
  void updateLayout() {
    _updateScreenInfo();
  }

  // ==================== Responsive Value Helpers ====================

  /// Generic responsive value selector
  T getResponsiveValue<T>({
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }

  /// Responsive width values (for backwards compatibility)
  double getResponsiveWidth({
    required double mobile,
    required double tablet,
    required double desktop,
  }) => getResponsiveValue(mobile: mobile, tablet: tablet, desktop: desktop);

  /// Responsive height values (for backwards compatibility)
  double getResponsiveHeight({
    required double mobile,
    required double tablet,
    required double desktop,
  }) => getResponsiveValue(mobile: mobile, tablet: tablet, desktop: desktop);

  /// Responsive column counts (common for grids)
  int getResponsiveColumns({
    required int mobile,
    required int tablet,
    required int desktop,
  }) => getResponsiveValue(mobile: mobile, tablet: tablet, desktop: desktop);

  /// Responsive axis (useful for layouts)
  Axis getResponsiveAxis({
    Axis mobile = Axis.vertical,
    Axis tablet = Axis.horizontal,
    Axis desktop = Axis.horizontal,
  }) => getResponsiveValue(mobile: mobile, tablet: tablet, desktop: desktop);

  /// Responsive alignment
  CrossAxisAlignment getResponsiveCrossAlignment({
    CrossAxisAlignment mobile = CrossAxisAlignment.center,
    CrossAxisAlignment tablet = CrossAxisAlignment.start,
    CrossAxisAlignment desktop = CrossAxisAlignment.start,
  }) => getResponsiveValue(mobile: mobile, tablet: tablet, desktop: desktop);
}

// ==================== Extensions for Easy Access ====================

/// Extension to easily access ResponsiveService from BuildContext
extension ResponsiveExtension on BuildContext {
  ResponsiveService get responsive => Get.find<ResponsiveService>();

  // Quick device type checks
  bool get isMobile => Get.find<ResponsiveService>().isMobile;
  bool get isTablet => Get.find<ResponsiveService>().isTablet;
  bool get isDesktop => Get.find<ResponsiveService>().isDesktop;
  bool get isLandscape => Get.find<ResponsiveService>().isLandscape;

  // Quick responsive value getter
  T responsiveValue<T>({
    required T mobile,
    required T tablet,
    required T desktop,
  }) => Get.find<ResponsiveService>().getResponsiveValue(
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
  );
}
