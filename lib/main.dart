import 'package:flutter/material.dart';

import 'data/repositories/news/news_repository_local.dart';
import 'ui/core/themes/app_theme.dart';
import 'ui/favorite/view_models/favorite_viewmodel.dart';
import 'ui/favorite/widgets/favorite_screen.dart';
import 'ui/home/view_models/home_viewmodel.dart';
import 'ui/home/widgets/home_screen.dart';
import 'ui/main/view_models/main_navigation_viewmodel.dart';
import 'ui/main/widgets/main_navigation_screen.dart';
import 'ui/news_detail/view_models/news_detail_viewmodel.dart';
import 'ui/news_detail/widgets/news_detail_screen.dart';
import 'ui/settings/view_models/settings_viewmodel.dart';
import 'ui/settings/widgets/settings_screen.dart';

void main() => runApp(const GemanatraApp());

class GemanatraApp extends StatefulWidget {
  const GemanatraApp({super.key});

  @override
  State<GemanatraApp> createState() => _GemanatraAppState();
}

class _GemanatraAppState extends State<GemanatraApp> {
  late final NewsRepositoryLocal _newsRepository;
  late final MainNavigationViewModel _navigationViewModel;
  late final HomeViewModel _homeViewModel;
  late final FavoriteViewModel _favoriteViewModel;
  late final SettingsViewModel _settingsViewModel;

  @override
  void initState() {
    super.initState();
    _newsRepository = NewsRepositoryLocal();
    _navigationViewModel = MainNavigationViewModel();
    _homeViewModel = HomeViewModel(repository: _newsRepository);
    _favoriteViewModel = FavoriteViewModel(repository: _newsRepository);
    _settingsViewModel = SettingsViewModel();
  }

  @override
  void dispose() {
    _navigationViewModel.dispose();
    _homeViewModel.dispose();
    _favoriteViewModel.dispose();
    _settingsViewModel.dispose();
    _newsRepository.dispose();
    super.dispose();
  }

  void _openNewsDetail(BuildContext context, String newsId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewsDetailScreen(
          viewModel: NewsDetailViewModel(
            repository: _newsRepository,
            newsId: newsId,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemanatra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Builder(
        builder: (context) {
          return MainNavigationScreen(
            viewModel: _navigationViewModel,
            homeScreen: HomeScreen(
              viewModel: _homeViewModel,
              onNewsTap: (newsId) => _openNewsDetail(context, newsId),
            ),
            favoriteScreen: FavoriteScreen(
              viewModel: _favoriteViewModel,
              onNewsTap: (newsId) => _openNewsDetail(context, newsId),
            ),
            settingsScreen: SettingsScreen(viewModel: _settingsViewModel),
          );
        },
      ),
    );
  }
}
