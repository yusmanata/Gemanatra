import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../data/repositories/news/news_repository.dart';
import '../../../domain/models/news_item.dart';

class FavoriteViewModel extends ChangeNotifier {
  FavoriteViewModel({required NewsRepository repository})
    : _newsRepository = repository {
    _newsRepository.addListener(_onRepositoryChanged);
  }

  final NewsRepository _newsRepository;

  UnmodifiableListView<NewsItem> get favorites =>
      UnmodifiableListView(_newsRepository.getFavoriteNews());

  bool get isEmpty => favorites.isEmpty;
  int get count => favorites.length;

  void removeFavorite(String id) {
    _newsRepository.removeFavorite(id);
  }

  void addFavorite(NewsItem item) {
    _newsRepository.toggleFavorite(item.id);
  }

  void playNewsVoice(String id) {
    // Placeholder pemutaran suara berita favorit
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
