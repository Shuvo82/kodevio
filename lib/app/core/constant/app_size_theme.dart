import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../utils/responsive_service.dart';

mixin AppSizeTheme {
  ThemeSize get size => ThemeSize.instance;
}

class ThemeSize {
  ThemeSize._();
  static ThemeSize? _instance;
  static ThemeSize get instance => _instance ?? (_instance = ThemeSize._());

  // ==================== Device Type Detection ====================
  // Uses ResponsiveService as single source of truth

  bool get isMobile {
    try {
      return Get.find<ResponsiveService>().isMobile;
    } catch (_) {
      // Fallback if ResponsiveService not initialized
      return 1.sw < ResponsiveService.mobileBreakpoint;
    }
  }

  bool get isTablet {
    try {
      return Get.find<ResponsiveService>().isTablet;
    } catch (_) {
      return 1.sw >= ResponsiveService.mobileBreakpoint &&
          1.sw < ResponsiveService.tabletBreakpoint;
    }
  }

  bool get isDesktop {
    try {
      return Get.find<ResponsiveService>().isDesktop;
    } catch (_) {
      return 1.sw >= ResponsiveService.tabletBreakpoint;
    }
  }

  // ==================== Scaling Helpers ====================

  /// Scales font sizes based on device type (aggressive scaling)
  double _scaledFont(double base) {
    if (isMobile) return base.sp; // Full scaling for phones
    if (isTablet) return base * 1.1; // Mild bump for tablets
    return base * 1.2; // Fixed boost for desktop
  }

  /// Scales layout elements (padding, radius, icons) with controlled scaling
  /// This prevents layout elements from becoming too large on desktop
  double _scaledHorizontal(double base) {
    if (isMobile) return base.w; // Full scaling for phones
    if (isTablet) return base * 1.05; // Very mild bump for tablets
    return base * 1.1; // Small fixed boost for desktop (max 10% increase)
  }

  /// Scales vertical spacing with controlled scaling
  double _scaledVertical(double base) {
    if (isMobile) return base.h; // Full scaling for phones
    if (isTablet) return base * 1.05; // Very mild bump for tablets
    return base * 1.1; // Small fixed boost for desktop
  }

  // ==================== Font Sizes with Responsive Scaling ====================

  double get textXXXXSmall => _scaledFont(8);
  double get textXXXSmall => _scaledFont(10);
  double get textXXSmall => _scaledFont(12);
  double get textXSmall => _scaledFont(14);
  double get textSmall => _scaledFont(16);
  double get textMedium => _scaledFont(18); //  Default body text size
  double get textLarge => _scaledFont(20);
  double get textXLarge => _scaledFont(22);
  double get textXXLarge => _scaledFont(26);
  double get textXXXLarge => _scaledFont(36);
  double get textXXXXLarge => _scaledFont(44);
  // ==================== Common Layout Sizes (Controlled Scaling) ====================

  // Border radius - controlled scaling to prevent over-rounding
  double get radiusSmall => _scaledHorizontal(6);
  double get radiusMedium => _scaledHorizontal(12);
  double get radiusLarge => _scaledHorizontal(20);

  // Padding presets - controlled scaling to prevent excessive spacing
  double get paddingSmall => _scaledHorizontal(8);
  double get paddingMedium => _scaledHorizontal(16);
  double get paddingLarge => _scaledHorizontal(24);

  // Icon sizes - controlled scaling to keep icons readable
  double get iconSmall => _scaledHorizontal(16);
  double get iconMedium => _scaledHorizontal(20);
  double get iconLarge => _scaledHorizontal(28);

  // Gap spacing - controlled vertical scaling
  double get gapSmall => _scaledVertical(6);
  double get gapMedium => _scaledVertical(12);
  double get gapLarge => _scaledVertical(20);
  double get gapExtraLarge => _scaledVertical(32);

  // ==================== Spacing System ====================
  // Vertical spacing for layouts
  double get spacingTiny => _scaledVertical(4);
  double get spacingSmall => _scaledVertical(8);
  double get spacingMedium => _scaledVertical(16);
  double get spacingLarge => _scaledVertical(24);
  double get spacingExtraLarge => _scaledVertical(32);
  double get spacingHuge => _scaledVertical(48);

  // Horizontal spacing for layouts
  double get spacingHorizontalTiny => _scaledHorizontal(4);
  double get spacingHorizontalSmall => _scaledHorizontal(8);
  double get spacingHorizontalMedium => _scaledHorizontal(16);
  double get spacingHorizontalLarge => _scaledHorizontal(24);
  double get spacingHorizontalExtraLarge => _scaledHorizontal(32);

  // ==================== Border Radius System ====================
  double get radiusTiny => _scaledHorizontal(4);
  double get radiusExtraLarge => _scaledHorizontal(16);
  double get radiusRound =>
      _scaledHorizontal(999); // For fully rounded elements

  // ==================== Border Width System ====================
  double get borderThin => 1.0;
  double get borderMedium => 2.0;
  double get borderThick => 3.0;
  double get borderWidth => 1.0; // Alias for borderThin

  // ==================== Padding Variants ====================
  double get paddingTiny => _scaledHorizontal(4);
  double get paddingExtraLarge => _scaledHorizontal(32);
  double get paddingHuge => _scaledHorizontal(48);

  // ==================== Size System ====================
  double get sizeSmall => _scaledHorizontal(32);
  double get sizeMedium => _scaledHorizontal(48);
  double get sizeLarge => _scaledHorizontal(64);
  double get sizeExtraLarge => _scaledHorizontal(96);

  // ==================== Margin System ====================
  double get marginTiny => _scaledVertical(4);
  double get marginSmall => _scaledVertical(8);
  double get marginMedium => _scaledVertical(16);
  double get marginLarge => _scaledVertical(24);
  double get marginExtraLarge => _scaledVertical(32);

  // ==================== Icon Size Variants ====================
  double get iconTiny => _scaledHorizontal(12);
  double get iconExtraLarge => _scaledHorizontal(36);
  double get iconHuge => _scaledHorizontal(48);

  // ==================== Button Sizes ====================
  // Button heights
  double get buttonHeightSmall => _scaledVertical(36);
  double get buttonHeightMedium => _scaledVertical(44);
  double get buttonHeightLarge => _scaledVertical(52);
  double get buttonHeightExtraLarge => _scaledVertical(60);

  // Button widths (for fixed-width buttons)
  double get buttonWidthSmall => _scaledHorizontal(80);
  double get buttonWidthMedium => _scaledHorizontal(120);
  double get buttonWidthLarge => _scaledHorizontal(160);
  double get buttonWidthFull => Get.width;

  // Button padding
  double get buttonPaddingHorizontalSmall => _scaledHorizontal(12);
  double get buttonPaddingHorizontalMedium => _scaledHorizontal(16);
  double get buttonPaddingHorizontalLarge => _scaledHorizontal(24);

  // ==================== Avatar/Profile Image Sizes ====================
  double get avatarSmall => _scaledHorizontal(32);
  double get avatarMedium => _scaledHorizontal(48);
  double get avatarLarge => _scaledHorizontal(64);
  double get avatarExtraLarge => _scaledHorizontal(96);
  double get avatarHuge => _scaledHorizontal(128);

  // ==================== Card/Container Sizes ====================
  double get cardPaddingSmall => _scaledHorizontal(12);
  double get cardPaddingMedium => _scaledHorizontal(16);
  double get cardPaddingLarge => _scaledHorizontal(20);

  double get cardMinHeight => _scaledVertical(80);
  double get cardMediumHeight => _scaledVertical(120);
  double get cardLargeHeight => _scaledVertical(180);

  // ==================== Input Field Sizes ====================
  double get inputHeightSmall => _scaledVertical(40);
  double get inputHeightMedium => _scaledVertical(48);
  double get inputHeightLarge => _scaledVertical(56);

  double get inputPaddingHorizontal => _scaledHorizontal(16);
  double get inputPaddingVertical => _scaledVertical(12);

  // ==================== AppBar & Toolbar Sizes ====================
  double get appBarHeight => _scaledVertical(56);
  double get toolbarHeight => _scaledVertical(48);
  double get bottomNavHeight => _scaledVertical(60);

  // ==================== Divider & Separator ====================
  double get dividerThickness => 1.0;
  double get dividerThicknessBold => 2.0;
  double get dividerSpacing => _scaledVertical(8);

  // ==================== Image Sizes ====================
  double get imageThumbSmall => _scaledHorizontal(60);
  double get imageThumbMedium => _scaledHorizontal(80);
  double get imageThumbLarge => _scaledHorizontal(120);

  double get imagePreviewSmall => _scaledHorizontal(150);
  double get imagePreviewMedium => _scaledHorizontal(200);
  double get imagePreviewLarge => _scaledHorizontal(300);

  // ==================== Dialog & Bottom Sheet ====================
  double get dialogPadding => _scaledHorizontal(24);
  double get dialogBorderRadius => _scaledHorizontal(16);
  double get dialogMinWidth => _scaledHorizontal(280);
  double get dialogMaxWidth => _scaledHorizontal(560);

  double get bottomSheetPadding => _scaledHorizontal(16);
  double get bottomSheetHandleWidth => _scaledHorizontal(40);
  double get bottomSheetHandleHeight => _scaledVertical(4);

  // ==================== Progress Indicator Sizes ====================
  double get progressIndicatorSmall => _scaledHorizontal(16);
  double get progressIndicatorMedium => _scaledHorizontal(24);
  double get progressIndicatorLarge => _scaledHorizontal(36);

  // ==================== Shadow & Elevation ====================
  double get elevationLow => 2.0;
  double get elevationMedium => 4.0;
  double get elevationHigh => 8.0;
  double get elevationExtraHigh => 16.0;

  // ==================== Screen Dimensions ====================
  // Full screen width (from Get)
  double get width => Get.width;

  // Full screen height (from Get)
  double get height => Get.height;

  // Common percentage widths
  double get widthHalf => Get.width * 0.5;
  double get widthThird => Get.width * 0.33;
  double get widthTwoThirds => Get.width * 0.66;
  double get widthQuarter => Get.width * 0.25;
  double get widthThreeQuarters => Get.width * 0.75;

  // Common percentage heights
  double get heightHalf => Get.height * 0.5;
  double get heightThird => Get.height * 0.33;
  double get heightTwoThirds => Get.height * 0.66;
  double get heightQuarter => Get.height * 0.25;
  double get heightThreeQuarters => Get.height * 0.75;
}
