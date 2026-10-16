import 'package:flutter/foundation.dart';

/// ViewModel untuk mengelola state navigasi tab utama (BottomNavigationBar).
/// Mengikuti aturan AGENTS.md: extends ChangeNotifier, tidak memegang BuildContext.
class MainNavigationViewModel extends ChangeNotifier {
  MainNavigationViewModel({int initialIndex = 0})
    : _currentIndex = initialIndex;

  int _currentIndex;

  int get currentIndex => _currentIndex;

  void selectTab(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }
}
