import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/app_scope.dart';
import '../../core/data/sample_weather.dart';
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
  static const _categories = ['Semua', 'Nasional', 'Teknologi', 'Kesehatan'];

  int _selectedCategory = 0;

  void _playWeatherVoice() {}

  void _playNewsVoice(String id) {}

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final textTheme = Theme.of(context).textTheme;
    final news = AppScope.of(context).news;

    return Scaffold(
      appBar: const GemanatraAppBar(),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dimens.maxContentWidth),
            child: ListenableBuilder(
              listenable: news,
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
                    children: [
                      WeatherCard(
                        weather: sampleWeather,
                        onListenPressed: _playWeatherVoice,
                      ),
                      SizedBox(height: dimens.spacingLarge),
                      CategoryChips(
                        categories: _categories,
                        selectedIndex: _selectedCategory,
                        onSelected: (index) =>
                            setState(() => _selectedCategory = index),
                      ),
                      SizedBox(height: dimens.spacingMedium),
                      Semantics(
                        header: true,
                        child: Text(
                          'Berita Utama',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      SizedBox(height: dimens.spacingMediumSmall),
                      for (final item in filteredNews) ...[
                        NewsCard(
                          key: ValueKey(item.id),
                          news: item,
                          onListen: () => _playNewsVoice(item.id),
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
