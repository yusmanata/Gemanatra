import 'package:flutter/material.dart';

import '../../../core/theme/dimens.dart';

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
          spacing: dimens.spacingSmall,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: dimens.spacingXSmall,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null)
                    Text(subtitle!, style: textTheme.bodyMedium),
                ],
              ),
            ),
            if (trailing != null)
              Flexible(
                flex: 2,
                child: Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: trailing!,
                ),
              ),
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
