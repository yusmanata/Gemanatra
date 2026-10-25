import 'package:flutter/material.dart';

import '../../../core/models/news_item.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/dimens.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.news,
    required this.onListen,
    this.onFavoriteToggle,
    this.showFavoriteButton = true,
    this.onTap,
  });

  final NewsItem news;
  final VoidCallback onListen;
  final VoidCallback? onFavoriteToggle;
  final bool showFavoriteButton;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimens = Dimens.of(context);

    return Semantics(
      container: true,
      label:
          'Berita kategori ${news.category}, dipublikasikan ${news.timeAgo}. Judul: ${news.title}. Estimasi durasi dengar ${news.durationText}. Ketuk untuk membaca detail berita.',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(dimens.borderRadiusLarge),
          child: Padding(
            padding: EdgeInsets.all(dimens.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: dimens.spacingMedium,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: dimens.spacingSmall,
                  children: [
                    Expanded(
                      child: Text(
                        news.category.toUpperCase(),
                        style: textTheme.labelMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      news.timeAgo,
                      style: textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showFavoriteButton && onFavoriteToggle != null)
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
                ),
                Text(news.title, style: textTheme.titleMedium),
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
      ),
    );
  }
}
