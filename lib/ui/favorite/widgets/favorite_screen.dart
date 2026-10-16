import 'package:flutter/material.dart';

import '../../core/themes/dimens.dart';
import '../../core/ui/gemanatra_app_bar.dart';
import '../../home/widgets/news_card.dart';
import '../view_models/favorite_viewmodel.dart';
import 'favorite_empty_view.dart';

/// Layar Berita Favorit.
/// Menampilkan daftar berita yang disimpan pengguna untuk didengarkan ulang.
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key, required this.viewModel});

  final FavoriteViewModel viewModel;

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
                  SizedBox(height: dimens.spacingSmall + 2.0),
                  for (final item in favorites) ...[
                    NewsCard(
                      key: ValueKey(item.id),
                      news: item,
                      onListen: () => viewModel.playNewsVoice(item.id),
                      onFavoriteToggle: () => viewModel.removeFavorite(item.id),
                    ),
                    SizedBox(height: dimens.spacingSmall + 4.0),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
