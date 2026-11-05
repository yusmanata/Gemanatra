import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/news_item.dart';

class FavoriteStore {
  const FavoriteStore();

  static const _key = 'favorite_news';

  Future<List<NewsItem>> read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return [];
      return [
        for (final json in jsonDecode(raw) as List)
          NewsItem.fromJson(json as Map<String, dynamic>),
      ];
    } on Exception {
      // Penyimpanan gagal atau data rusak tidak boleh menghalangi berita dimuat.
      return [];
    }
  }

  Future<void> write(List<NewsItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _key,
        jsonEncode([for (final item in items) item.toJson()]),
      );
    } on Exception {
      // Gagal menyimpan hanya berarti favorit tidak bertahan setelah aplikasi ditutup.
    }
  }
}
