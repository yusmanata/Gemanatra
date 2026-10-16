/// Model domain immutable untuk artikel berita.
/// Mengikuti aturan AGENTS.md (immutable model, no public setters).
class NewsItem {
  const NewsItem({
    required this.id,
    required this.category,
    required this.title,
    required this.timeAgo,
    required this.durationText,
    this.isFavorite = false,
  });

  final String id;
  final String category;
  final String title;
  final String timeAgo;
  final String durationText;
  final bool isFavorite;

  NewsItem copyWith({
    String? id,
    String? category,
    String? title,
    String? timeAgo,
    String? durationText,
    bool? isFavorite,
  }) {
    return NewsItem(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      timeAgo: timeAgo ?? this.timeAgo,
      durationText: durationText ?? this.durationText,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
