/// Model domain immutable untuk artikel berita.
/// Mengikuti aturan AGENTS.md (immutable model, no public setters).
class NewsItem {
  const NewsItem({
    required this.id,
    required this.category,
    required this.title,
    required this.timeAgo,
    required this.durationText,
    this.author = 'Redaksi Gemanatra',
    this.content = '',
    this.isFavorite = false,
  });

  final String id;
  final String category;
  final String title;
  final String timeAgo;
  final String durationText;
  final String author;
  final String content;
  final bool isFavorite;

  NewsItem copyWith({
    String? id,
    String? category,
    String? title,
    String? timeAgo,
    String? durationText,
    String? author,
    String? content,
    bool? isFavorite,
  }) {
    return NewsItem(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      timeAgo: timeAgo ?? this.timeAgo,
      durationText: durationText ?? this.durationText,
      author: author ?? this.author,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
