import 'package:flutter/material.dart';

import 'ui/core/themes/app_theme.dart';
import 'ui/favorite/view_models/favorite_viewmodel.dart';
import 'ui/favorite/widgets/favorite_screen.dart';
import 'ui/home/view_models/home_viewmodel.dart';
import 'ui/home/widgets/home_screen.dart';
import 'ui/main/view_models/main_navigation_viewmodel.dart';
import 'ui/main/widgets/main_navigation_screen.dart';
import 'ui/settings/view_models/settings_viewmodel.dart';
import 'ui/settings/widgets/settings_screen.dart';

void main() => runApp(const GemanatraApp());

/// Root widget aplikasi Gemanatra.
/// Menginisialisasi dependensi tema terpusat dan lifecycle ViewModel.
class GemanatraApp extends StatefulWidget {
  const GemanatraApp({super.key});

  @override
  State<GemanatraApp> createState() => _GemanatraAppState();
}

class _GemanatraAppState extends State<GemanatraApp> {
  late final MainNavigationViewModel _navigationViewModel;
  late final HomeViewModel _homeViewModel;
  late final FavoriteViewModel _favoriteViewModel;
  late final SettingsViewModel _settingsViewModel;

  @override
  void initState() {
    super.initState();
    _navigationViewModel = MainNavigationViewModel();
    _homeViewModel = HomeViewModel();
    _favoriteViewModel = FavoriteViewModel();
    _settingsViewModel = SettingsViewModel();
  }

  @override
  void dispose() {
    _navigationViewModel.dispose();
    _homeViewModel.dispose();
    _favoriteViewModel.dispose();
    _settingsViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemanatra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MainNavigationScreen(
        viewModel: _navigationViewModel,
        homeScreen: HomeScreen(viewModel: _homeViewModel),
        favoriteScreen: FavoriteScreen(viewModel: _favoriteViewModel),
        settingsScreen: SettingsScreen(viewModel: _settingsViewModel),
      ),
    );
  }
}
