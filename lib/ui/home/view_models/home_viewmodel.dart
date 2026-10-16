import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../domain/models/news_item.dart';
import '../../../domain/models/weather_summary.dart';

/// ViewModel untuk layar Beranda (Home).
/// Mengikuti aturan AGENTS.md: memisahkan state & logic dari Widget,
/// mengekspos data immutable, dan tidak mengimpor BuildContext.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({WeatherSummary? initialWeather, List<NewsItem>? initialNews})
    : _weather =
          initialWeather ??
          const WeatherSummary(
            location: 'DKI Jakarta',
            temperature: '29°C',
            condition: 'Cerah Berawan',
            details: 'Kelembapan: 72% • Angin: 14 km/jam',
          ),
      _categories = const ['Semua', 'Nasional', 'Teknologi', 'Kesehatan'],
      _newsList =
          initialNews ??
          const [
            NewsItem(
              id: '1',
              category: 'Teknologi',
              timeAgo: '15 menit lalu',
              title: 'Inovasi Navigasi Suara untuk Disabilitas Netra Resmi Diluncurkan',
              durationText: '2 Menit',
              isFavorite: false,
            ),
            NewsItem(
              id: '2',
              category: 'Nasional',
              timeAgo: '1 jam lalu',
              title: 'Pemerintah Memperluas Fasilitas Guiding Block di Seluruh Stasiun Kereta',
              durationText: '3 Menit',
              isFavorite: true,
            ),
            NewsItem(
              id: '3',
              category: 'Kesehatan',
              timeAgo: '2 jam lalu',
              title: 'Kementerian Kesehatan Kenalkan Rekam Medis Berbantuan Suara untuk Pasien Low Vision',
              durationText: '4 Menit',
              isFavorite: false,
            ),
          ];

  final WeatherSummary _weather;
  final List<String> _categories;
  int _selectedCategoryIndex = 0;
  List<NewsItem> _newsList;

  WeatherSummary get weather => _weather;
  UnmodifiableListView<String> get categories =>
      UnmodifiableListView(_categories);
  int get selectedCategoryIndex => _selectedCategoryIndex;

  /// Daftar berita yang telah difilter sesuai kategori yang dipilih.
  UnmodifiableListView<NewsItem> get filteredNews {
    if (_selectedCategoryIndex == 0) {
      return UnmodifiableListView(_newsList);
    }
    final selectedCategory = _categories[_selectedCategoryIndex].toLowerCase();
    final filtered = _newsList
        .where((item) => item.category.toLowerCase() == selectedCategory)
        .toList();
    return UnmodifiableListView(filtered);
  }

  void selectCategory(int index) {
    if (_selectedCategoryIndex == index) return;
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    _newsList = _newsList.map((item) {
      if (item.id == id) {
        return item.copyWith(isFavorite: !item.isFavorite);
      }
      return item;
    }).toList();
    notifyListeners();
  }

  void playWeatherVoice() {
    // Placeholder untuk aksi integrasi TTS cuaca
  }

  void playNewsVoice(String id) {
    // Placeholder untuk aksi pemutaran audio berita
  }
}
