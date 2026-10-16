import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../domain/models/news_item.dart';

/// ViewModel untuk layar Berita Favorit.
/// Mengelola daftar berita yang disimpan oleh pengguna.
class FavoriteViewModel extends ChangeNotifier {
  FavoriteViewModel({List<NewsItem>? initialFavorites})
    : _favorites =
          initialFavorites ??
          const [
            NewsItem(
              id: '2',
              category: 'Nasional',
              timeAgo: '1 jam lalu',
              title: 'Pemerintah Memperluas Fasilitas Guiding Block di Seluruh Stasiun Kereta',
              durationText: '3 Menit',
              isFavorite: true,
            ),
            NewsItem(
              id: '4',
              category: 'Teknologi',
              timeAgo: 'Kemarin',
              title: 'Kacamata Pintar dengan Sensor Ultrasonik untuk Tunanetra Mulai Diuji Coba',
              durationText: '3 Menit',
              isFavorite: true,
            ),
          ];

  List<NewsItem> _favorites;

  UnmodifiableListView<NewsItem> get favorites =>
      UnmodifiableListView(_favorites);

  bool get isEmpty => _favorites.isEmpty;
  int get count => _favorites.length;

  void removeFavorite(String id) {
    _favorites = _favorites.where((item) => item.id != id).toList();
    notifyListeners();
  }

  void addFavorite(NewsItem item) {
    if (_favorites.any((existing) => existing.id == item.id)) return;
    _favorites = [..._favorites, item.copyWith(isFavorite: true)];
    notifyListeners();
  }

  void playNewsVoice(String id) {
    // Placeholder pemutaran suara berita favorit
  }
}
