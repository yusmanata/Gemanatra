import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/dimens.dart';

/// Badge indikator status TTS (Text to Speech) aktif.
/// Dilengkapi semantik suara untuk aksesibilitas pembaca layar (TalkBack).
class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    super.key,
    this.label = 'TTS AKTIF',
    this.isActive = true,
  });

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimens = Dimens.of(context);

    final bgColor = isActive ? AppColors.statusGreenBg : AppColors.surface;
    final fgColor = isActive ? AppColors.statusGreen : AppColors.textSecondary;

    return Semantics(
      label: 'Status fitur pembaca suara: $label',
      readOnly: true,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dimens.spacingSmall + 2.0,
          vertical: dimens.spacingXSmall + 1.0,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(dimens.borderRadiusLarge),
          border: Border.all(color: fgColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? Icons.record_voice_over : Icons.voice_over_off,
              color: fgColor,
              size: dimens.iconSizeSmall - 2.0,
            ),
            SizedBox(width: dimens.spacingXSmall + 1.0),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: fgColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
