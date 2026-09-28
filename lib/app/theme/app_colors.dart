import 'package:flutter/material.dart';

/// Palet warna terpusat untuk aplikasi Gemanatra.
/// Menggunakan standar kontras tinggi WCAG AAA untuk memudahkan tunanetra & low-vision.
class AppColors {
  AppColors._();

  // Latar Belakang & Permukaan (Clear White Theme)
  static const Color background = Color(0xFFFFFFFF); // Putih jernih
  static const Color surface = Color(0xFFF8FAFC); // Kartu latar abu-abu sangat muda
  static const Color border = Color(0xFFE2E8F0); // Garis batas halus & bersih

  // Brand & Aksen Utama (Kuning Emas & Biru)
  static const Color primary = Color(0xFFFBBF24); // Kuning emas kontras tinggi
  static const Color onPrimary = Color(0xFF000000); // Hitam pekat di atas tombol kuning
  static const Color primaryDark = Color(0xFFD97706); // Kuning amber gelap untuk ikon/teks di atas putih
  static const Color secondary = Color(0xFF0284C7); // Biru aksen tajam

  // Teks & Tipografi
  static const Color textPrimary = Color(0xFF0F172A); // Hitam arang tajam & terbaca
  static const Color textSecondary = Color(0xFF64748B); // Abu-abu slate teks sekunder
  static const Color weatherAlert = Color(0xFFB45309); // Amber gelap untuk kondisi cuaca

  // Status Aksesibilitas TTS
  static const Color statusGreen = Color(0xFF16A34A); // Hijau status TTS aktif
  static const Color statusGreenBg = Color(0xFFDCFCE7); // Latar pil status hijau muda

  // Navigasi Bawah
  static const Color navBackground = Color(0xFFFFFFFF); // Putih bersih
}
