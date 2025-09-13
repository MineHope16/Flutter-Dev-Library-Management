import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/Colors.dart';
import '../utils/AppTheme.dart';

/// Professional Theme Provider for OpenLibrary Book Explorer
/// Manages theme state, persistence, and provides comprehensive theming API
class ThemeProvider extends ChangeNotifier {
  // =============================================================================
  // PRIVATE FIELDS
  // =============================================================================

  /// Current theme mode
  ThemeMode _themeMode = ThemeMode.system;

  /// Shared preferences instance for persistence
  SharedPreferences? _prefs;

  /// Preference key for theme storage
  static const String _themePrefKey = 'theme_mode';

  // =============================================================================
  // PUBLIC GETTERS
  // =============================================================================

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Whether current mode is dark theme
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Whether current mode is light theme
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Whether current mode follows system theme
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Get current theme mode as display string
  String get themeModeDisplayName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  // =============================================================================
  // BACKWARD COMPATIBILITY GETTERS
  // =============================================================================
  // These maintain compatibility with existing code

  /// Background Color (Gradient)
  LinearGradient get backgroundColor => AppTheme.getGradient(isDarkMode);

  /// Text Primary Color
  Color get primaryTextColor => isDarkMode
      ? AppColors.nightModePrimaryTextColor
      : AppColors.dayModePrimaryTextColor;

  /// Text Secondary Color
  Color get secondaryTextColor => isDarkMode
      ? AppColors.nightModeSecondaryTextColor
      : AppColors.dayModeSecondaryTextColor;

  /// Button Background Color
  Color get buttonBackgroundColor => isDarkMode
      ? AppColors.nightButtonBackground
      : AppColors.dayButtonBackground;

  /// Button Text Color
  Color get buttonTextColor =>
      isDarkMode ? AppColors.nightButtonText : AppColors.dayButtonText;

  // =============================================================================
  // INITIALIZATION
  // =============================================================================

  /// Initialize theme provider with stored preferences
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadThemeMode();
    } catch (e) {
      debugPrint('ThemeProvider: Failed to initialize preferences: $e');
      // Continue with default theme mode
    }
  }

  /// Load theme mode from preferences
  Future<void> _loadThemeMode() async {
    try {
      final storedMode = _prefs?.getString(_themePrefKey);
      if (storedMode != null) {
        _themeMode = _parseThemeMode(storedMode);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('ThemeProvider: Failed to load theme mode: $e');
    }
  }

  /// Save theme mode to preferences
  Future<void> _saveThemeMode() async {
    try {
      await _prefs?.setString(_themePrefKey, _themeMode.toString());
    } catch (e) {
      debugPrint('ThemeProvider: Failed to save theme mode: $e');
    }
  }

  /// Parse theme mode from string
  ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  // =============================================================================
  // PUBLIC METHODS
  // =============================================================================

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      await _saveThemeMode();
    }
  }

  /// Toggle between light and dark themes
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Get theme icon based on current mode
  IconData get themeIcon {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Get next theme mode for cycling through options
  ThemeMode get nextThemeMode {
    switch (_themeMode) {
      case ThemeMode.system:
        return ThemeMode.light;
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.dark:
        return ThemeMode.system;
    }
  }

  /// Cycle through theme modes
  Future<void> cycleThemeMode() async {
    await setThemeMode(nextThemeMode);
  }

  // =============================================================================
  // BACKWARD COMPATIBILITY METHODS
  // =============================================================================
  // These maintain compatibility with existing code

  /// Toggle theme (backward compatibility)
  @Deprecated('Use toggleTheme() instead')
  void toggleMode() {
    toggleTheme();
  }

  /// Set theme (backward compatibility)
  @Deprecated('Use setThemeMode() instead')
  void setTheme(bool isNight) {
    setThemeMode(isNight ? ThemeMode.dark : ThemeMode.light);
  }

  /// Check if night mode (backward compatibility)
  @Deprecated('Use isDarkMode instead')
  bool get isNightMode => isDarkMode;

  // =============================================================================
  // HELPER METHODS
  // =============================================================================

  /// Check if theme should be dark based on context and current settings
  bool shouldUseDarkTheme(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  /// Get appropriate theme data based on context
  ThemeData getThemeData(BuildContext context) {
    return shouldUseDarkTheme(context)
        ? AppTheme.darkTheme
        : AppTheme.lightTheme;
  }

  /// Reset to default theme
  Future<void> resetToDefault() async {
    await setThemeMode(ThemeMode.system);
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}
