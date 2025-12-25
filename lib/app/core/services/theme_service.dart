import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constant/app_colors.dart';
import 'storage_manager_service.dart';

/// Theme modes available in the app
enum AppThemeMode { system, light, dark }

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  // Current theme mode (system, light, dark)
  final Rx<AppThemeMode> _themeMode = AppThemeMode.system.obs;

  // The actual theme data being used
  final _themeData = lightThemeData.obs;

  @override
  void onInit() {
    _loadTheme();
    super.onInit();
  }

  ThemeData get themeData => _themeData.value;
  AppThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode {
    if (_themeMode.value == AppThemeMode.system) {
      // Check system brightness
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode.value == AppThemeMode.dark;
  }

  /// Get the ThemeMode for MaterialApp
  ThemeMode get materialThemeMode {
    switch (_themeMode.value) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  /// Set theme mode
  void setThemeMode(AppThemeMode mode) {
    _themeMode.value = mode;
    _updateThemeData();
    _saveTheme();

    // Update the app's theme mode
    Get.changeThemeMode(materialThemeMode);
  }

  /// Toggle between light and dark (ignoring system)
  void toggleTheme() {
    if (_themeMode.value == AppThemeMode.dark) {
      setThemeMode(AppThemeMode.light);
    } else {
      setThemeMode(AppThemeMode.dark);
    }
  }

  void _updateThemeData() {
    if (_themeMode.value == AppThemeMode.system) {
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      _themeData.value = brightness == Brightness.dark
          ? darkThemeData
          : lightThemeData;
    } else {
      _themeData.value = _themeMode.value == AppThemeMode.dark
          ? darkThemeData
          : lightThemeData;
    }
  }

  void _saveTheme() {
    String modeString;
    switch (_themeMode.value) {
      case AppThemeMode.system:
        modeString = 'system';
        break;
      case AppThemeMode.light:
        modeString = 'light';
        break;
      case AppThemeMode.dark:
        modeString = 'dark';
        break;
    }
    StorageManagerService.to.write(StorageKey.themeMode, modeString);
  }

  void _loadTheme() {
    String? savedMode = StorageManagerService.to.read<String>(
      StorageKey.themeMode,
    );

    if (savedMode == null) {
      // Default to system theme
      _themeMode.value = AppThemeMode.system;
    } else {
      switch (savedMode) {
        case 'light':
          _themeMode.value = AppThemeMode.light;
          break;
        case 'dark':
          _themeMode.value = AppThemeMode.dark;
          break;
        default:
          _themeMode.value = AppThemeMode.system;
      }
    }
    _updateThemeData();
  }

  /// Get theme mode display name
  String getThemeModeDisplayName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  /// Get theme mode icon
  IconData getThemeModeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return Icons.brightness_auto_rounded;
      case AppThemeMode.light:
        return Icons.light_mode_rounded;
      case AppThemeMode.dark:
        return Icons.dark_mode_rounded;
    }
  }
}

ThemeData lightThemeData = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,

    error: AppColors.error,
    onError: Color.fromARGB(255, 49, 155, 0), //for error text
    onPrimary: Color(0xff261751),
    surface: AppColors.surfaceLight, //for bg
    onSurface: Color.fromARGB(255, 255, 255, 255), // for header
    //tertiary is for text color
    tertiary: AppColors.black, //for black text
    onTertiary: AppColors.disabled, //for subtext
    tertiaryContainer: AppColors.white,
    tertiaryFixed: AppColors.white,
    tertiaryFixedDim: AppColors.black,

    surfaceContainerHighest: Color(0xffFFEDED),
    onSurfaceVariant: Color(0xffBC0100),
  ),
  textTheme: GoogleFonts.interTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.urbanist(
      color: AppColors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.disabled),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.disabled),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: GoogleFonts.urbanist(color: AppColors.disabled),
  ),
);

ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 225, 214, 255),
    secondary: const Color.fromARGB(255, 17, 0, 255),

    error: Colors.red.shade300,
    onError: const Color.fromARGB(255, 210, 255, 189), //for error text

    surface: AppColors.surfaceDark, //for bg
    onSurface: const Color.fromARGB(255, 29, 39, 68), //for header background
    //tertiary is for text color
    tertiary: Colors.white, //for white text
    onTertiary: const Color.fromARGB(255, 160, 160, 160), //for subtext
    tertiaryContainer: Colors.black,
    tertiaryFixed: Colors.white,
    tertiaryFixedDim: Colors.black,

    surfaceContainerHighest: const Color(0xff292929),
    onSurfaceVariant: const Color(0xffBC0100),
  ),
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.urbanist(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 225, 214, 255),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color.fromARGB(255, 29, 39, 68),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color.fromARGB(255, 160, 160, 160)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color.fromARGB(255, 160, 160, 160)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 225, 214, 255),
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade300),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: GoogleFonts.urbanist(
      color: const Color.fromARGB(255, 160, 160, 160),
    ),
  ),
);
