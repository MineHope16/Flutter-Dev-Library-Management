import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Professional theme configuration for OpenLibrary Book Explorer
/// Following Material Design 3 principles with custom branding
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // =============================================================================
  // COLOR SCHEMES
  // =============================================================================

  /// Light theme color scheme
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1976D2), // Primary blue
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFBBDEFB),
    onPrimaryContainer: Color(0xFF0D47A1),
    secondary: Color(0xFF03DAC6), // Teal accent
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFFB2DFDB),
    onSecondaryContainer: Color(0xFF004D40),
    tertiary: Color(0xFF9C27B0), // Purple
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFE1BEE7),
    onTertiaryContainer: Color(0xFF4A148C),
    error: Color(0xFFD32F2F),
    onError: Colors.white,
    errorContainer: Color(0xFFFFCDD2),
    onErrorContainer: Color(0xFFB71C1C),
    background: Color(0xFFF8F9FA),
    onBackground: Color(0xFF1A1A1A),
    surface: Colors.white,
    onSurface: Color(0xFF1A1A1A),
    surfaceVariant: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF424242),
    outline: Color(0xFFBDBDBD),
    outlineVariant: Color(0xFFE0E0E0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF2E2E2E),
    onInverseSurface: Color(0xFFF5F5F5),
    inversePrimary: Color(0xFF90CAF9),
    surfaceTint: Color(0xFF1976D2),
  );

  /// Dark theme color scheme
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF90CAF9), // Lighter blue for dark mode
    onPrimary: Color(0xFF0D47A1),
    primaryContainer: Color(0xFF1565C0),
    onPrimaryContainer: Color(0xFFE3F2FD),
    secondary: Color(0xFF80CBC4), // Lighter teal
    onSecondary: Color(0xFF00251A),
    secondaryContainer: Color(0xFF00695C),
    onSecondaryContainer: Color(0xFFB2DFDB),
    tertiary: Color(0xFFCE93D8), // Lighter purple
    onTertiary: Color(0xFF4A148C),
    tertiaryContainer: Color(0xFF7B1FA2),
    onTertiaryContainer: Color(0xFFF3E5F5),
    error: Color(0xFFEF5350),
    onError: Color(0xFFB71C1C),
    errorContainer: Color(0xFFC62828),
    onErrorContainer: Color(0xFFFFCDD2),
    background: Color(0xFF0F0F0F),
    onBackground: Color(0xFFE8E8E8),
    surface: Color(0xFF1A1A1A),
    onSurface: Color(0xFFE8E8E8),
    surfaceVariant: Color(0xFF2A2A2A),
    onSurfaceVariant: Color(0xFFC0C0C0),
    outline: Color(0xFF757575),
    outlineVariant: Color(0xFF424242),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE8E8E8),
    onInverseSurface: Color(0xFF1A1A1A),
    inversePrimary: Color(0xFF1976D2),
    surfaceTint: Color(0xFF90CAF9),
  );

  // =============================================================================
  // GRADIENT BACKGROUNDS
  // =============================================================================

  /// Light mode gradient background
  static const LinearGradient lightGradient = LinearGradient(
    colors: [
      Color(0xFF89F7FE), // Light cyan
      Color(0xFF66A6FF), // Light blue
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  /// Dark mode gradient background
  static const LinearGradient darkGradient = LinearGradient(
    colors: [
      Color(0xFF141E30), // Dark navy
      Color(0xFF243B55), // Deep blue
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  // =============================================================================
  // TEXT THEMES
  // =============================================================================

  /// Light text theme
  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.25,
      color: Color(0xFF1A1A1A),
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w300,
      letterSpacing: 0,
      color: Color(0xFF1A1A1A),
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFF1A1A1A),
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFF1A1A1A),
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFF1A1A1A),
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFF1A1A1A),
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Color(0xFF1A1A1A),
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Color(0xFF1A1A1A),
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFF1A1A1A),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      color: Color(0xFF424242),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Color(0xFF424242),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Color(0xFF616161),
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFF1A1A1A),
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFF424242),
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFF616161),
    ),
  );

  /// Dark text theme
  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.25,
      color: Color(0xFFE8E8E8),
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w300,
      letterSpacing: 0,
      color: Color(0xFFE8E8E8),
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFFE8E8E8),
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFFE8E8E8),
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFFE8E8E8),
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFFE8E8E8),
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Color(0xFFE8E8E8),
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Color(0xFFE8E8E8),
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFFE8E8E8),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      color: Color(0xFFC0C0C0),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Color(0xFFC0C0C0),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Color(0xFF9E9E9E),
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFFE8E8E8),
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFFC0C0C0),
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFF9E9E9E),
    ),
  );

  // =============================================================================
  // APPBAR THEMES
  // =============================================================================

  static AppBarTheme _lightAppBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 4,
    backgroundColor: Colors.transparent,
    foregroundColor: _lightColorScheme.onSurface,
    titleTextStyle: _lightTextTheme.titleLarge,
    toolbarTextStyle: _lightTextTheme.bodyMedium,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    iconTheme: IconThemeData(color: _lightColorScheme.onSurface),
    actionsIconTheme: IconThemeData(color: _lightColorScheme.onSurface),
  );

  static AppBarTheme _darkAppBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 4,
    backgroundColor: Colors.transparent,
    foregroundColor: _darkColorScheme.onSurface,
    titleTextStyle: _darkTextTheme.titleLarge,
    toolbarTextStyle: _darkTextTheme.bodyMedium,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    iconTheme: IconThemeData(color: _darkColorScheme.onSurface),
    actionsIconTheme: IconThemeData(color: _darkColorScheme.onSurface),
  );

  // =============================================================================
  // BUTTON THEMES
  // =============================================================================

  static ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.25,
      ),
    ),
  );

  static OutlinedButtonThemeData _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.25,
      ),
    ),
  );

  static TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.25,
      ),
    ),
  );

  // =============================================================================
  // INPUT THEMES
  // =============================================================================

  static InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    filled: true,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
    ),
  );

  // =============================================================================
  // CARD THEMES
  // =============================================================================

  static CardThemeData _cardTheme = CardThemeData(
    elevation: 2,
    shadowColor: Colors.black26,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    clipBehavior: Clip.antiAlias,
  );

  // =============================================================================
  // DIVIDER THEMES
  // =============================================================================

  static const DividerThemeData _dividerTheme = DividerThemeData(
    thickness: 1,
    space: 1,
  );

  // =============================================================================
  // PUBLIC THEME DATA
  // =============================================================================

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      textTheme: _lightTextTheme,
      appBarTheme: _lightAppBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme.copyWith(
        fillColor: _lightColorScheme.surfaceVariant,
      ),
      cardTheme: _cardTheme,
      dividerTheme: _dividerTheme.copyWith(color: _lightColorScheme.outline),
      scaffoldBackgroundColor: _lightColorScheme.background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      textTheme: _darkTextTheme,
      appBarTheme: _darkAppBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme.copyWith(
        fillColor: _darkColorScheme.surfaceVariant,
      ),
      cardTheme: _cardTheme,
      dividerTheme: _dividerTheme.copyWith(color: _darkColorScheme.outline),
      scaffoldBackgroundColor: _darkColorScheme.background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // =============================================================================
  // HELPER METHODS
  // =============================================================================

  /// Get appropriate gradient based on theme mode
  static LinearGradient getGradient(bool isDark) {
    return isDark ? darkGradient : lightGradient;
  }

  /// Get system navigation bar color
  static SystemUiOverlayStyle getSystemUiOverlay(bool isDark) {
    return isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
  }

  /// Check if current theme is dark
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get opposite theme mode
  static ThemeMode getOppositeMode(ThemeMode current) {
    switch (current) {
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.dark:
        return ThemeMode.light;
      case ThemeMode.system:
        return ThemeMode.light; // Default fallback
    }
  }
}
