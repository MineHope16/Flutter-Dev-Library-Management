import 'package:flutter/material.dart';
import '../Configuration/Colors.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isNightMode = false;
  bool get isNightMode => _isNightMode;

  /// Background Color
  LinearGradient get backgroundColor => _isNightMode
      ? AppColors.nightModeBackgroundColor
      : AppColors.dayModeBackgroundColor;

  /// Text Primary Color
  Color get primaryTextColor => _isNightMode
      ? AppColors.nightModePrimaryTextColor
      : AppColors.dayModePrimaryTextColor;

  /// Text Secondary Color
  Color get secondaryTextColor => _isNightMode
      ? AppColors.nightModeSecondaryTextColor
      : AppColors.dayModeSecondaryTextColor;

  /// Button Background Color
  Color get buttonBackgroundColor => _isNightMode
      ? AppColors.nightButtonBackground
      : AppColors.dayButtonBackground;

  /// Button Text Color
  Color get buttonTextColor => _isNightMode
      ? AppColors.nightButtonText
      : AppColors.dayButtonText;

  void toggleTheme() {
    _isNightMode = !_isNightMode;
    notifyListeners();
  }

  void setTheme(bool isNight) {
    _isNightMode = isNight;
    notifyListeners();
  }
}
