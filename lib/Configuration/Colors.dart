import 'package:flutter/material.dart';

class AppColors{

  /// Background Color with Night Mode (Gradient)
  static const LinearGradient dayModeBackgroundColor = LinearGradient(
    colors: [
      Color(0xFF89F7FE),
      Color(0xFF66A6FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Background Color with Day Mode (Gradient)
  static const LinearGradient nightModeBackgroundColor = LinearGradient(
    colors: [
      Color(0xFF141E30), // dark navy
      Color(0xFF243B55), // deep blue
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Primary Text Color with Day Mode
  static const Color dayModePrimaryTextColor = Colors.black87;

  /// Primary Text Color with Night Mode
  static const Color nightModePrimaryTextColor = Colors.white;

  /// Secondary Text Color with Day Mode
  static const Color dayModeSecondaryTextColor = Colors.black54;

  /// Secondary Text Color with Night Mode
  static const Color nightModeSecondaryTextColor = Colors.white70;

  /// Button Background with Day Mode
  static const Color dayButtonBackground = Color(0xFF1976D2);

  /// Button BackGround with Day Mode
  static const Color nightButtonBackground = Color(0xFFBB86FC); // purple

  /// Button Text Colors with Day Mode
  static const Color dayButtonText = Colors.white;

  /// Button Text Color with Night Mode
  static const Color nightButtonText = Colors.black;
}