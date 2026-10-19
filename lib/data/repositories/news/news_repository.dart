import '../../../domain/models/news_item.dart';

/// Kontrak Repository untuk pengelolaan data berita.
/// Sesuai aturan AGENTS.md §3.2:
/// Repository adalah satu-satunya sumber kebenaran (single source of truth)
/// untuk satu jenis data.
abstract class NewsRepository {
  /// Mengambil semua daftar berita.
  List<NewsItem> getAllNews();

  /// Mengambil daftar berita yang ditandai sebagai favorit.
  List<NewsItem> getFavoriteNews();

  /// Mengambil satu berita spesifik berdasarkan id.
  NewsItem? getNewsById(String id);

  /// Mengubah status favorit berita berdasarkan id.
  void toggleFavorite(String id);

  /// Menghapus berita dari favorit berdasarkan id.
  void removeFavorite(String id);

  /// Menambahkan listener untuk mendengarkan perubahan data.
  void addListener(void Function() listener);

  /// Menghapus listener.
  void removeListener(void Function() listener);
}
