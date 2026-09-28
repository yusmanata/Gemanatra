import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tema terpusat Material 3 untuk aplikasi Gemanatra.
/// Memusatkan Component Theme (Card, Button, Chip, AppBar, BottomNav)
/// dan Typography (TextTheme) sehingga widget di halaman mewarisi gaya secara konsisten.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,

      // 1. Color Scheme Dasar (Design Tokens to Theme)
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        outline: AppColors.border,
      ),

      // 2. Skala Tipografi Terpusat (TextTheme)
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
        // Untuk subjudul seksi (Kategori Berita, Berita Utama, Judul Artikel)
        titleMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        // Untuk teks informasi sekunder (kelembapan, waktu, lokasi)
        bodyMedium: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        // Untuk label tombol dan chip
        labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w800,
          color: AppColors.onPrimary,
        ),
        // Untuk label kategori huruf kapital (CUACA HARI INI, TEKNOLOGI)
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

      // 3. AppBar Theme (Header Atas Bersih)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16.0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),

      // 4. Card Theme (Menggantikan Container berulang)
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(color: AppColors.border, width: 1.0),
        ),
      ),

      // 5. Elevated Button Theme (Tombol Masif Ramah Tunanetra)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          minimumSize: const Size.fromHeight(50.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // 6. Chip Theme (Kategori Berita)
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
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      ),

      // 7. Bottom Navigation Bar Theme (Navigasi Bawah)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.navBackground,
        elevation: 0,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12.0,
        ),
        type: BottomNavigationBarType.fixed,
      ),

      // 8. Divider Theme (Pemisah Garis Halus)
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
