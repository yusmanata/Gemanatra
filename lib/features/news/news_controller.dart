import 'package:flutter/foundation.dart';

import '../../core/data/sample_news.dart';
import '../../core/models/news_item.dart';

/// Sumber tunggal daftar berita dan status favorit, dipakai Home, Favorit, dan Detail.
class NewsController extends ChangeNotifier {
  List<NewsItem> _news = sampleNews;

  List<NewsItem> get news => List.unmodifiable(_news);

  List<NewsItem> get favorites =>
      List.unmodifiable(_news.where((item) => item.isFavorite));

  /// Berita pada category; kategori tidak dikenal menghasilkan daftar kosong.
  List<NewsItem> byCategory(String category) => List.unmodifiable(
    _news.where(
      (item) => item.category.toLowerCase() == category.toLowerCase(),
    ),
  );

  NewsItem? findById(String id) {
    for (final item in _news) {
      if (item.id == id) return item;
    }
    return null;
  }

  void toggleFavorite(String id) {
    if (findById(id) == null) return;
    _news = [
      for (final item in _news)
        if (item.id == id)
          item.copyWith(isFavorite: !item.isFavorite)
        else
          item,
    ];
    notifyListeners();
  }
}
