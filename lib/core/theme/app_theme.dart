import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'dimens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    const dimens = Dimens.standard;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,

      // Color Scheme Dasar
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        outline: AppColors.border,
        error: AppColors.error,
      ),

      // Skala Tipografi Terpusat (TextTheme)
      textTheme: const TextTheme(
        // Untuk angka suhu besar (29°C)
        displayLarge: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
          letterSpacing: -1.0,
        ),
        // Untuk judul utama AppBar & judul header
        titleLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        // Untuk subjudul seksi & judul artikel
        titleMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.35,
        ),
        // Untuk judul ubin pengaturan (SettingTile)
        titleSmall: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        // Untuk isi paragraf berita lengkap (Detail Berita)
        bodyLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
        // Untuk teks informasi sekunder
        bodyMedium: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        // Untuk label tombol dan chip
        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w800,
          color: AppColors.onPrimary,
        ),
        // Untuk label kategori huruf kapital
        labelMedium: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w800,
          color: AppColors.secondary,
          letterSpacing: 0.8,
        ),
        // Untuk tagline kecil dan badge
        labelSmall: TextStyle(
          fontSize: 11.0,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
        ),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16.0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dimens.borderRadiusLarge),
          side: const BorderSide(color: AppColors.border, width: 1.0),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          minimumSize: Size.fromHeight(dimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dimens.borderRadiusStandard),
          ),
          textStyle: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: Size.fromHeight(dimens.minTouchTarget),
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dimens.borderRadiusStandard),
          ),
          textStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dimens.borderRadiusMedium),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: dimens.chipPaddingHorizontal,
          vertical: dimens.chipPaddingVertical,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.navBackground,
        elevation: 0,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 12.0),
        type: BottomNavigationBarType.fixed,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1.0,
        space: 1.0,
      ),

      // 10. Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onPrimary;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.border;
        }),
      ),
    );
  }
}
