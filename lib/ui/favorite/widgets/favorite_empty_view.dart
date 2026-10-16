import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/dimens.dart';

/// Tampilan ketika daftar favorit masih kosong.
/// Mengutamakan kejelasan teks dan semantik ramah tunanetra.
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
          padding: EdgeInsets.all(dimens.cardPadding * 1.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_border_rounded,
                  size: 40.0,
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
                style: textTheme.bodyMedium?.copyWith(height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
