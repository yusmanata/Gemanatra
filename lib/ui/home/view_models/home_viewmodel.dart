import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../data/repositories/news/news_repository.dart';
import '../../../domain/models/news_item.dart';
import '../../../domain/models/weather_summary.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required NewsRepository repository,
    WeatherSummary? initialWeather,
  }) : _newsRepository = repository,
       _weather =
           initialWeather ??
           const WeatherSummary(
             location: 'DKI Jakarta',
             temperature: '29°C',
             condition: 'Cerah Berawan',
             details: 'Kelembapan: 72% • Angin: 14 km/jam',
           ),
       _categories = const ['Semua', 'Nasional', 'Teknologi', 'Kesehatan'] {
    _newsRepository.addListener(_onRepositoryChanged);
  }

  final NewsRepository _newsRepository;
  final WeatherSummary _weather;
  final List<String> _categories;
  int _selectedCategoryIndex = 0;

  WeatherSummary get weather => _weather;
  UnmodifiableListView<String> get categories =>
      UnmodifiableListView(_categories);
  int get selectedCategoryIndex => _selectedCategoryIndex;

  /// Daftar berita yang telah difilter sesuai kategori yang dipilih.
  UnmodifiableListView<NewsItem> get filteredNews {
    final allNews = _newsRepository.getAllNews();
    if (_selectedCategoryIndex == 0) {
      return UnmodifiableListView(allNews);
    }
    final selectedCategory = _categories[_selectedCategoryIndex].toLowerCase();
    final filtered = allNews
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
    _newsRepository.toggleFavorite(id);
  }

  void playWeatherVoice() {
    // Placeholder untuk aksi integrasi TTS cuaca
  }

  void playNewsVoice(String id) {
    // Placeholder untuk aksi pemutaran audio berita
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _newsRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
