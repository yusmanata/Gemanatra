import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../favorites/favorites_screen.dart';
import '../home/home_screen.dart';
import '../settings/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga state tiap tab (scroll, kategori) saat berpindah.
      body: IndexedStack(
        index: _index,
        // Urutan harus sama dengan urutan items di BottomNavigationBar.
        children: const [HomeScreen(), FavoritesScreen(), SettingsScreen()],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (index) => setState(() => _index = index),
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
