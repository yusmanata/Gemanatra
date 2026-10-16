import 'package:flutter/material.dart';

import '../../core/themes/dimens.dart';
import '../../core/ui/gemanatra_app_bar.dart';
import '../view_models/home_viewmodel.dart';
import 'category_chips.dart';
import 'news_card.dart';
import 'weather_card.dart';

/// Layar Beranda utama aplikasi Gemanatra.
/// Menampilkan ringkasan cuaca, filter kategori, dan daftar berita utama.
/// Mengikuti pola MVVM sesuai AGENTS.md (StatelessWidget + ListenableBuilder).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const GemanatraAppBar(),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final filteredNews = viewModel.filteredNews;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: dimens.paddingScreenHorizontal,
                vertical: dimens.paddingScreenVertical,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Kartu Ringkasan Cuaca
                  WeatherCard(
                    weather: viewModel.weather,
                    onListenPressed: viewModel.playWeatherVoice,
                  ),
                  SizedBox(height: dimens.spacingLarge),

                  // 2. Kategori Berita
                  CategoryChips(
                    categories: viewModel.categories,
                    selectedIndex: viewModel.selectedCategoryIndex,
                    onSelected: viewModel.selectCategory,
                  ),
                  SizedBox(height: dimens.spacingMedium),

                  // 3. Judul Seksi Berita Utama
                  Semantics(
                    header: true,
                    child: Text('Berita Utama', style: textTheme.titleMedium),
                  ),
                  SizedBox(height: dimens.spacingSmall + 2.0),

                  // 4. Daftar Kartu Berita
                  for (final news in filteredNews) ...[
                    NewsCard(
                      key: ValueKey(news.id),
                      news: news,
                      onListen: () => viewModel.playNewsVoice(news.id),
                      onFavoriteToggle: () => viewModel.toggleFavorite(news.id),
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
