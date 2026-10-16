import 'package:flutter/material.dart';

/// Palet warna terpusat untuk aplikasi Gemanatra.
/// Menggunakan standar kontras tinggi WCAG AAA untuk memudahkan tunanetra & low-vision.
class AppColors {
  AppColors._();

  // Latar Belakang & Permukaan (Clear White Theme)
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);

  // Brand & Aksen Utama (Kuning Emas & Biru)
  static const Color primary = Color(0xFFFBBF24);
  static const Color onPrimary = Color(0xFF000000);
  static const Color primaryDark = Color(0xFFD97706);
  static const Color secondary = Color(0xFF0284C7);

  // Teks & Tipografi
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color weatherAlert = Color(0xFFB45309);

  // Status & Indikator
  static const Color statusGreen = Color(0xFF16A34A);
  static const Color statusGreenBg = Color(0xFFDCFCE7);
  static const Color error = Color(0xFFDC2626);

  // Navigasi Bawah
  static const Color navBackground = Color(0xFFFFFFFF);
}
