import 'package:flutter/material.dart';

import '../../../domain/models/news_item.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/dimens.dart';

/// Kartu artikel berita yang dilengkapi tombol pemutar suara.
/// Didesain dengan kontras tinggi WCAG AAA dan semantik ramah tunanetra.
class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.news,
    required this.onListen,
    this.onFavoriteToggle,
    this.showFavoriteButton = true,
  });

  final NewsItem news;
  final VoidCallback onListen;
  final VoidCallback? onFavoriteToggle;
  final bool showFavoriteButton;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimens = Dimens.of(context);

    return Semantics(
      container: true,
      label:
          'Berita kategori ${news.category}, dipublikasikan ${news.timeAgo}. Judul: ${news.title}. Estimasi durasi dengar ${news.durationText}.',
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(dimens.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      news.category.toUpperCase(),
                      style: textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: dimens.spacingSmall),
                  Text(news.timeAgo, style: textTheme.bodyMedium),
                  if (showFavoriteButton && onFavoriteToggle != null) ...[
                    SizedBox(width: dimens.spacingSmall),
                    Semantics(
                      label: news.isFavorite
                          ? 'Hapus dari berita favorit'
                          : 'Simpan ke berita favorit',
                      button: true,
                      child: IconButton(
                        icon: Icon(
                          news.isFavorite
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          color: news.isFavorite
                              ? AppColors.primaryDark
                              : AppColors.textSecondary,
                          size: dimens.iconSizeMedium,
                        ),
                        onPressed: onFavoriteToggle,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: dimens.minTouchTarget,
                          minHeight: dimens.minTouchTarget,
                        ),
                        tooltip: news.isFavorite
                            ? 'Tersimpan di Favorit'
                            : 'Simpan ke Favorit',
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: dimens.spacingSmall),
              Text(
                news.title,
                style: textTheme.titleMedium?.copyWith(height: 1.35),
              ),
              SizedBox(height: dimens.spacingMedium - 2.0),
              ElevatedButton.icon(
                onPressed: onListen,
                icon: Icon(
                  Icons.headphones_rounded,
                  size: dimens.iconSizeMedium,
                ),
                label: Text('Dengarkan Berita (${news.durationText})'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
