import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == currentIndex,
          ),
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
  }
}
