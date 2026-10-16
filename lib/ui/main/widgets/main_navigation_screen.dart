import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../favorite/widgets/favorite_screen.dart';
import '../../home/widgets/home_screen.dart';
import '../../settings/widgets/settings_screen.dart';
import '../view_models/main_navigation_viewmodel.dart';

/// Shell navigasi utama aplikasi dengan BottomNavigationBar.
/// Menggunakan IndexedStack untuk mempertahankan state masing-masing tab.
/// Sesuai aturan AGENTS.md (StatelessWidget + ListenableBuilder).
class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({
    super.key,
    required this.viewModel,
    required this.homeScreen,
    required this.favoriteScreen,
    required this.settingsScreen,
  });

  final MainNavigationViewModel viewModel;
  final HomeScreen homeScreen;
  final FavoriteScreen favoriteScreen;
  final SettingsScreen settingsScreen;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final currentIndex = viewModel.currentIndex;

        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: [homeScreen, favoriteScreen, settingsScreen],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.border, width: 1.0),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: viewModel.selectTab,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Utama',
                  tooltip: 'Tab Berita & Cuaca Utama',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_outline_rounded),
                  activeIcon: Icon(Icons.bookmark_rounded),
                  label: 'Favorit',
                  tooltip: 'Tab Berita Favorit',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings_rounded),
                  label: 'Pengaturan',
                  tooltip: 'Tab Pengaturan Aplikasi & Suara',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
