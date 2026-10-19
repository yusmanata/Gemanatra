import 'package:flutter/material.dart';

import '../../core/themes/dimens.dart';

class SettingSection extends StatelessWidget {
  const SettingSection({
    super.key,
    required this.title,
    required this.children,
    this.icon,
  });

  final String title;
  final IconData? icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimens = Dimens.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: dimens.iconSizeMediumSmall,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: dimens.spacingSmall),
              ],
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: dimens.spacingMediumSmall),
        Card(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dimens.cardPadding,
              vertical: dimens.spacingSmall,
            ),
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: dimens.spacingXSmall,
                      ),
                      child: const Divider(),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
