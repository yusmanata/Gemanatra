import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/dimens.dart';
import 'app_status_badge.dart';

/// AppBar utama aplikasi Gemanatra dengan logo, judul suara, dan badge status TTS.
/// Seluruh dimensi diambil murni dari Dimens tanpa nilai ajaib / hardcoded.
class GemanatraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GemanatraAppBar({
    super.key,
    this.title = 'Gemanatra',
    this.subtitle = 'Suara Berita & Cuaca',
    this.showTtsBadge = true,
  });

  final String title;
  final String subtitle;
  final bool showTtsBadge;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimens = Dimens.of(context);

    return AppBar(
      title: Row(
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
          SizedBox(width: dimens.spacingMediumSmall),
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
        ],
      ),
      actions: [
        if (showTtsBadge)
          Padding(
            padding: EdgeInsets.only(right: dimens.paddingScreenHorizontal),
            child: const AppStatusBadge(),
          ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(),
      ),
    );
  }
}
