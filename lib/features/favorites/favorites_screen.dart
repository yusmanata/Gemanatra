import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/app_scope.dart';
import '../../core/theme/dimens.dart';
import '../../core/widgets/gemanatra_app_bar.dart';
import '../home/widgets/news_card.dart';
import 'widgets/favorite_empty_view.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final textTheme = Theme.of(context).textTheme;
    final news = AppScope.of(context).news;

    return Scaffold(
      appBar: const GemanatraAppBar(
        title: 'Favorit',
        subtitle: 'Koleksi Berita Tersimpan',
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dimens.maxContentWidth),
            child: ListenableBuilder(
              listenable: news,
              builder: (context, _) {
                final favorites = news.favorites;
                if (favorites.isEmpty) {
                  return const FavoriteEmptyView();
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: dimens.paddingScreenHorizontal,
                    vertical: dimens.paddingScreenVertical,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          '${favorites.length} Berita Tersimpan',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      SizedBox(height: dimens.spacingMediumSmall),
                      for (final item in favorites) ...[
                        NewsCard(
                          key: ValueKey(item.id),
                          news: item,
                          // shortcut: suara berita belum tersambung ke TTS, ganti saat TTS dibuat.
                          onListen: () {},
                          onFavoriteToggle: () => news.toggleFavorite(item.id),
                          onTap: () =>
                              context.push(AppRoutes.newsDetail(item.id)),
                        ),
                        SizedBox(height: dimens.spacingMedium),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
