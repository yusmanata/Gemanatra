import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/dimens.dart';

class GemanatraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GemanatraAppBar({
    super.key,
    this.title = 'Gemanatra',
    this.subtitle = 'Suara Berita & Cuaca',
  });

  final String title;
  final String subtitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimens = Dimens.of(context);

    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: dimens.spacingMediumSmall,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(dimens.borderRadiusSmall),
            child: Image.asset(
              'assets/images/logo.jpg',
              width: dimens.avatarSize,
              height: dimens.avatarSize,
              fit: BoxFit.cover,
              semanticLabel: 'Logo Gemanatra',
              errorBuilder: (_, _, _) => Icon(
                Icons.volume_up_rounded,
                color: AppColors.primaryDark,
                size: dimens.iconSizeLarge,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: textTheme.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(children: [
            Text("halo bo", style: textTheme.titleMedium),
          ],)
        ],
      ),
    );
  }
}
