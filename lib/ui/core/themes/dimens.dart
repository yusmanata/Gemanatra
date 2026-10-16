import 'package:flutter/widgets.dart';

/// Konfigurasi dimensi dan spasi terpusat.
/// Mengikuti rekomendasi AGENTS.md (Compass App pattern) agar tidak ada
/// nilai padding atau ukuran piksel yang di-hardcode di dalam widget fitur.
class Dimens {
  const Dimens({
    this.paddingScreenHorizontal = 16.0,
    this.paddingScreenVertical = 12.0,
    this.cardPadding = 16.0,
    this.spacingXSmall = 4.0,
    this.spacingSmall = 8.0,
    this.spacingMedium = 16.0,
    this.spacingLarge = 20.0,
    this.spacingXLarge = 24.0,
    this.minTouchTarget = 48.0,
    this.buttonHeight = 50.0,
    this.iconSizeSmall = 16.0,
    this.iconSizeMedium = 22.0,
    this.iconSizeLarge = 32.0,
    this.borderRadiusSmall = 8.0,
    this.borderRadiusMedium = 12.0,
    this.borderRadiusLarge = 16.0,
  });

  final double paddingScreenHorizontal;
  final double paddingScreenVertical;
  final double cardPadding;
  final double spacingXSmall;
  final double spacingSmall;
  final double spacingMedium;
  final double spacingLarge;
  final double spacingXLarge;
  final double minTouchTarget;
  final double buttonHeight;
  final double iconSizeSmall;
  final double iconSizeMedium;
  final double iconSizeLarge;
  final double borderRadiusSmall;
  final double borderRadiusMedium;
  final double borderRadiusLarge;

  static const Dimens standard = Dimens();

  /// Mengambil dimensi berdasarkan ukuran layar (responsif).
  static Dimens of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > 600) {
      return const Dimens(
        paddingScreenHorizontal: 32.0,
        paddingScreenVertical: 20.0,
        cardPadding: 24.0,
        spacingXSmall: 6.0,
        spacingSmall: 12.0,
        spacingMedium: 20.0,
        spacingLarge: 28.0,
        spacingXLarge: 32.0,
        minTouchTarget: 52.0,
        buttonHeight: 56.0,
        iconSizeSmall: 18.0,
        iconSizeMedium: 26.0,
        iconSizeLarge: 36.0,
        borderRadiusSmall: 10.0,
        borderRadiusMedium: 14.0,
        borderRadiusLarge: 20.0,
      );
    }
    return standard;
  }
}
