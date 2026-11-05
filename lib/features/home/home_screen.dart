import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/router.dart';
import '../../core/app_scope.dart';
import '../../core/services/news_service.dart';
import '../../core/theme/dimens.dart';
import '../../core/widgets/gemanatra_app_bar.dart';
import 'widgets/category_chips.dart';
import 'widgets/news_card.dart';
import 'widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final _categories = ['Semua', ...NewsService.categories.values];

  int _selectedCategory = 0;

  void _playWeatherVoice() {}

  void _playNewsVoice(String id) {}

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final textTheme = Theme.of(context).textTheme;
    final scope = AppScope.of(context);
    final news = scope.news;
    final weather = scope.weather;

    return Scaffold(
      appBar: const GemanatraAppBar(),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dimens.maxContentWidth),
            child: ListenableBuilder(
              listenable: Listenable.merge([news, weather]),
              builder: (context, _) {
                final filteredNews = _selectedCategory == 0
                    ? news.news
                    : news.byCategory(_categories[_selectedCategory]);

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: dimens.paddingScreenHorizontal,
                    vertical: dimens.paddingScreenVertical,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: dimens.spacingMedium,
                    children: [
                      if (weather.error != null)
                        _ErrorView(
                          message: weather.error!,
                          onRetry: weather.load,
                        )
                      else
                        WeatherCard(
                          weather: weather.weather,
                          onListenPressed: _playWeatherVoice,
                        ),
                      CategoryChips(
                        categories: _categories,
                        selectedIndex: _selectedCategory,
                        onSelected: (index) =>
                            setState(() => _selectedCategory = index),
                      ),
                      Semantics(
                        header: true,
                        child: Text(
                          'Berita Utama',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      if (news.isLoading)
                        Center(
                          child: Semantics(
                            label: 'Sedang memuat berita',
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      else if (news.error != null)
                        _ErrorView(message: news.error!, onRetry: news.load),
                      for (final item in filteredNews) ...[
                        NewsCard(
                          key: ValueKey(item.id),
                          news: item,
                          onListen: () => _playNewsVoice(item.id),
                          onFavoriteToggle: () => news.toggleFavorite(item.id),
                          onTap: () =>
                              Get.toNamed(AppRoutes.newsDetail(item.id)),
                        ),
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);

    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: dimens.spacingMedium,
        children: [
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }
}
