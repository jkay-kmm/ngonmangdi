import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.orange,
        brightness: Brightness.light,
        primary: AppColors.orange,
        secondary: AppColors.yellow,
        surface: Colors.white,
        background: Colors.white,
        onSurface: AppColors.drak,
        onBackground: AppColors.drak,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.drak,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: AppFont.semi_default_20.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppFont.semi_default_20.copyWith(fontSize: 24),
        displayMedium: AppFont.semi_default_20,
        displaySmall: AppFont.semi_default_18,
        headlineLarge: AppFont.semi_default_20,
        headlineMedium: AppFont.semi_default_18,
        headlineSmall: AppFont.semi_default_16,
        titleLarge: AppFont.regular_default_18.copyWith(
          fontWeight: FontWeight.w600,
        ),
        titleMedium: AppFont.regular_default_16.copyWith(
          fontWeight: FontWeight.w600,
        ),
        titleSmall: AppFont.regular_default_14.copyWith(
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: AppFont.regular_default_16,
        bodyMedium: AppFont.regular_default_14,
        bodySmall: AppFont.regular_default_12,
        labelLarge: AppFont.regular_default_14.copyWith(
          fontWeight: FontWeight.w500,
        ),
        labelMedium: AppFont.regular_default_12.copyWith(
          fontWeight: FontWeight.w500,
        ),
        labelSmall: AppFont.regular_default_10.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.orange.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: AppFont.regular_default_16.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.orange_light_2.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.orange, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: AppFont.regular_default_14.copyWith(color: AppColors.light),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.orange,
        unselectedItemColor: AppColors.light,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppFont.regular_default_12.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppFont.regular_default_12,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.orange_light_2,
        selectedColor: AppColors.orange,
        labelStyle: AppFont.regular_default_12,
        secondaryLabelStyle: AppFont.regular_default_12.copyWith(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.orange,
        linearTrackColor: AppColors.orange_light_2,
        circularTrackColor: AppColors.orange_light_2,
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: AppColors.drak, size: 24),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.light.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.orange,
        brightness: Brightness.dark,
        primary: AppColors.orange_bright,
        secondary: AppColors.yellow_bright,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),

      // Tương tự light theme nhưng với màu dark
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: AppFont.semi_default_20.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      cardTheme: CardTheme(
        color: const Color(0xFF2C2C2C),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
