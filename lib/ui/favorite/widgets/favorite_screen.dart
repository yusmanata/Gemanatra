import 'package:flutter/material.dart';

import '../../core/themes/dimens.dart';
import '../../core/ui/gemanatra_app_bar.dart';
import '../../home/widgets/news_card.dart';
import '../view_models/favorite_viewmodel.dart';
import 'favorite_empty_view.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key, required this.viewModel, this.onNewsTap});

  final FavoriteViewModel viewModel;
  final ValueChanged<String>? onNewsTap;

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final textTheme = Theme.of(context).textTheme;

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
              listenable: viewModel,
              builder: (context, _) {
                if (viewModel.isEmpty) {
                  return const FavoriteEmptyView();
                }

                final favorites = viewModel.favorites;

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
                          '${viewModel.count} Berita Tersimpan',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      SizedBox(height: dimens.spacingMediumSmall),
                      for (final item in favorites) ...[
                        NewsCard(
                          key: ValueKey(item.id),
                          news: item,
                          onListen: () => viewModel.playNewsVoice(item.id),
                          onFavoriteToggle: () =>
                              viewModel.removeFavorite(item.id),
                          onTap: onNewsTap != null
                              ? () => onNewsTap!(item.id)
                              : null,
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
