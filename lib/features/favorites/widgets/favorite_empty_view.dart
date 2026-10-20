import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/dimens.dart';

class FavoriteEmptyView extends StatelessWidget {
  const FavoriteEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimens = Dimens.of(context);

    return Semantics(
      container: true,
      label: 'Halaman berita favorit masih kosong. Anda belum menyimpan berita apapun.',
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(dimens.emptyStatePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: dimens.emptyStateContainerSize,
                height: dimens.emptyStateContainerSize,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  size: dimens.iconSizeXLarge,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: dimens.spacingMedium),
              Text(
                'Belum Ada Berita Favorit',
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: dimens.spacingSmall),
              Text(
                'Simpan berita penting dengan menekan ikon simpan agar dapat Anda dengarkan kembali dengan mudah kapan saja.',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
