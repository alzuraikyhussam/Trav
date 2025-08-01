import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2E86AB);
  static const Color primaryLight = Color(0xFF4FA4C7);
  static const Color primaryDark = Color(0xFF1E5F7E);
  
  // Secondary Colors
  static const Color secondary = Color(0xFFF24236);
  static const Color secondaryLight = Color(0xFFFF6B61);
  static const Color secondaryDark = Color(0xFFD32F2F);
  
  // Accent Colors
  static const Color accent = Color(0xFFF6AE2D);
  static const Color accentLight = Color(0xFFFFBF47);
  static const Color accentDark = Color(0xFFE09900);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF424242);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFFBDBDBD);
  
  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF2E86AB),
    Color(0xFF4FA4C7),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFFF24236),
    Color(0xFFFF6B61),
  ];
  
  static const List<Color> accentGradient = [
    Color(0xFFF6AE2D),
    Color(0xFFFFBF47),
  ];
  
  // Opacity Colors
  static Color primaryWithOpacity(double opacity) => primary.withOpacity(opacity);
  static Color secondaryWithOpacity(double opacity) => secondary.withOpacity(opacity);
  static Color blackWithOpacity(double opacity) => black.withOpacity(opacity);
  static Color whiteWithOpacity(double opacity) => white.withOpacity(opacity);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
  static const Color borderDark = Color(0xFF757575);
}