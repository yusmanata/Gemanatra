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
    this.publishedAt,
    this.isFavorite = false,
  });

  factory NewsItem.fromGuardian(Map<String, dynamic> json, String category) {
    final fields = json['fields'] as Map<String, dynamic>? ?? const {};
    final body = _htmlToParagraphs(fields['body'] as String? ?? '');
    final words = body.split(RegExp(r'\s+')).length;
    final minutes = (words / 200).ceil().clamp(1, 99);
    final published = DateTime.tryParse(
      json['webPublicationDate'] as String? ?? '',
    );

    return NewsItem(
      // Id Guardian berisi '/', diganti agar aman sebagai segmen path GetX.
      id: (json['id'] as String).replaceAll('/', '~'),
      category: category,
      title: json['webTitle'] as String? ?? '',
      timeAgo: _timeAgo(published),
      durationText: '$minutes Menit',
      author: (fields['byline'] as String?)?.trim().isNotEmpty ?? false
          ? fields['byline'] as String
          : 'The Guardian',
      content: body,
      publishedAt: published,
    );
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    final published = DateTime.tryParse(json['publishedAt'] as String? ?? '');
    return NewsItem(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      timeAgo: _timeAgo(published),
      durationText: json['durationText'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      publishedAt: published,
      isFavorite: true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'title': title,
    'durationText': durationText,
    'author': author,
    'content': content,
    'publishedAt': publishedAt?.toIso8601String(),
  };

  // bodyText Guardian tanpa pemisah paragraf, jadi memakai HTML `body` lalu dipecah per </p>.
  static String _htmlToParagraphs(String html) {
    final text = html
        .replaceAll(RegExp(r'<(figure|aside)[\s\S]*?</(figure|aside)>'), '')
        .replaceAll(RegExp(r'</(p|h\d|li|blockquote)>|<br\s*/?>'), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&');
    return text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join('\n\n');
  }

  static String _timeAgo(DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes.clamp(1, 59)} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  final String id;
  final String category;
  final String title;
  final String timeAgo;
  final String durationText;
  final String author;
  final String content;
  final DateTime? publishedAt;
  final bool isFavorite;

  NewsItem copyWith({
    String? id,
    String? category,
    String? title,
    String? timeAgo,
    String? durationText,
    String? author,
    String? content,
    DateTime? publishedAt,
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
      publishedAt: publishedAt ?? this.publishedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
