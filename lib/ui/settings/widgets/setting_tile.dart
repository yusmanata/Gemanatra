import 'package:flutter/material.dart';

import '../../core/themes/dimens.dart';

/// Item ubin pengaturan tunggal dengan semantik aksesibilitas tinggi.
class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.semanticLabel,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimens = Dimens.of(context);

    final tileContent = ConstrainedBox(
      constraints: BoxConstraints(minHeight: dimens.minTouchTarget),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: dimens.spacingSmall),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(fontSize: 15.0),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: dimens.spacingXSmall),
                    Text(subtitle!, style: textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: dimens.spacingSmall),
              trailing!,
            ],
          ],
        ),
      ),
    );

    return Semantics(
      label: semanticLabel ?? '$title. ${subtitle ?? ''}',
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(dimens.borderRadiusSmall),
        child: tileContent,
      ),
    );
  }
}
