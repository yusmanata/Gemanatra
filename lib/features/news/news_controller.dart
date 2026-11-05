import 'package:flutter/foundation.dart';

import '../../core/models/news_item.dart';
import '../../core/services/favorite_store.dart';
import '../../core/services/news_service.dart';

class NewsController extends ChangeNotifier {
  final _service = const NewsService();
  final _store = const FavoriteStore();

  List<NewsItem> _news = [];
  List<NewsItem> _favorites = [];
  bool _restored = false;
  bool _isLoading = false;
  String? _error;

  List<NewsItem> get news => List.unmodifiable(_news);

  bool get isLoading => _isLoading;

  String? get error => _error;

  List<NewsItem> get favorites => List.unmodifiable(_favorites);

  List<NewsItem> byCategory(String category) => List.unmodifiable(
    _news.where(
      (item) => item.category.toLowerCase() == category.toLowerCase(),
    ),
  );

  NewsItem? findById(String id) {
    for (final item in [..._news, ..._favorites]) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (!_restored) {
        _favorites = await _store.read();
        _restored = true;
      }
      _news = _markFavorites(await _service.fetchNews());
    } on Exception {
      _error = 'Gagal memuat berita. Periksa koneksi internet lalu coba lagi.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<NewsItem> _markFavorites(List<NewsItem> items) {
    final ids = {for (final item in _favorites) item.id};
    return [
      for (final item in items)
        item.copyWith(isFavorite: ids.contains(item.id)),
    ];
  }

  void toggleFavorite(String id) {
    final item = findById(id);
    if (item == null) return;
    if (item.isFavorite) {
      _favorites = [
        for (final saved in _favorites)
          if (saved.id != id) saved,
      ];
    } else {
      _favorites = [item.copyWith(isFavorite: true), ..._favorites];
    }
    _news = _markFavorites(_news);
    notifyListeners();
    _store.write(_favorites);
  }
}
