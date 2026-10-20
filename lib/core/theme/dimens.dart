import 'package:flutter/widgets.dart';

class Dimens {
  const Dimens({
    // Spasi & Jarak
    this.spacingTiny = 2.0,
    this.spacingXSmall = 4.0,
    this.spacingSmall = 8.0,
    this.spacingMediumSmall = 10.0,
    this.spacingMedium = 12.0,
    this.spacingMediumLarge = 14.0,
    this.spacingLarge = 16.0,
    this.spacingXLarge = 20.0,
    this.spacingXXLarge = 24.0,
    this.spacingHuge = 32.0,

    // Padding Layar & Komponen
    this.paddingScreenHorizontal = 16.0,
    this.paddingScreenVertical = 12.0,
    this.cardPadding = 16.0,
    this.emptyStatePadding = 24.0,
    this.badgePaddingHorizontal = 10.0,
    this.badgePaddingVertical = 5.0,
    this.chipPaddingHorizontal = 10.0,
    this.chipPaddingVertical = 6.0,

    // Ukuran Elemen & Target Sentuh
    this.minTouchTarget = 48.0,
    this.buttonHeight = 50.0,
    this.avatarSize = 36.0,
    this.emptyStateContainerSize = 80.0,
    this.maxContentWidth = 720.0,

    // Ukuran Ikon
    this.iconSizeTiny = 14.0,
    this.iconSizeSmall = 16.0,
    this.iconSizeMediumSmall = 18.0,
    this.iconSizeMedium = 22.0,
    this.iconSizeMediumLarge = 24.0,
    this.iconSizeLarge = 32.0,
    this.iconSizeXLarge = 40.0,

    // Border Radius
    this.borderRadiusSmall = 8.0,
    this.borderRadiusMedium = 10.0,
    this.borderRadiusStandard = 12.0,
    this.borderRadiusLarge = 16.0,
  });

  // Spasi
  final double spacingTiny;
  final double spacingXSmall;
  final double spacingSmall;
  final double spacingMediumSmall;
  final double spacingMedium;
  final double spacingMediumLarge;
  final double spacingLarge;
  final double spacingXLarge;
  final double spacingXXLarge;
  final double spacingHuge;

  // Padding
  final double paddingScreenHorizontal;
  final double paddingScreenVertical;
  final double cardPadding;
  final double emptyStatePadding;
  final double badgePaddingHorizontal;
  final double badgePaddingVertical;
  final double chipPaddingHorizontal;
  final double chipPaddingVertical;

  // Ukuran Komponen
  final double minTouchTarget;
  final double buttonHeight;
  final double avatarSize;
  final double emptyStateContainerSize;
  final double maxContentWidth;

  // Ikon
  final double iconSizeTiny;
  final double iconSizeSmall;
  final double iconSizeMediumSmall;
  final double iconSizeMedium;
  final double iconSizeMediumLarge;
  final double iconSizeLarge;
  final double iconSizeXLarge;

  // Radius
  final double borderRadiusSmall;
  final double borderRadiusMedium;
  final double borderRadiusStandard;
  final double borderRadiusLarge;

  static const Dimens standard = Dimens();

  /// Mengambil dimensi responsif berdasarkan lebar layar saat ini.
  static Dimens of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > 600) {
      return const Dimens(
        spacingTiny: 3.0,
        spacingXSmall: 6.0,
        spacingSmall: 10.0,
        spacingMediumSmall: 12.0,
        spacingMedium: 14.0,
        spacingMediumLarge: 16.0,
        spacingLarge: 20.0,
        spacingXLarge: 24.0,
        spacingXXLarge: 28.0,
        spacingHuge: 40.0,
        paddingScreenHorizontal: 24.0,
        paddingScreenVertical: 16.0,
        cardPadding: 20.0,
        emptyStatePadding: 32.0,
        badgePaddingHorizontal: 12.0,
        badgePaddingVertical: 6.0,
        chipPaddingHorizontal: 12.0,
        chipPaddingVertical: 8.0,
        minTouchTarget: 52.0,
        buttonHeight: 54.0,
        avatarSize: 40.0,
        emptyStateContainerSize: 96.0,
        maxContentWidth: 720.0,
        iconSizeTiny: 16.0,
        iconSizeSmall: 18.0,
        iconSizeMediumSmall: 20.0,
        iconSizeMedium: 24.0,
        iconSizeMediumLarge: 26.0,
        iconSizeLarge: 36.0,
        iconSizeXLarge: 48.0,
        borderRadiusSmall: 10.0,
        borderRadiusMedium: 12.0,
        borderRadiusStandard: 14.0,
        borderRadiusLarge: 20.0,
      );
    }
    return standard;
  }
}
