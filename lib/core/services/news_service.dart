import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/news_item.dart';

class NewsService {
  const NewsService();

  // shortcut: key lewat --dart-define, tanpa penyimpanan aman; ganti bila ada backend proxy.
  static const _apiKey = String.fromEnvironment(
    'GUARDIAN_API_KEY',
    defaultValue: '',
  );

  static const categories = {
    'world': 'Dunia',
    'technology': 'Teknologi',
    'science': 'Sains',
    'business': 'Bisnis',
  };

  // Melempar Exception bila gagal; controller yang menangkapnya.
  Future<List<NewsItem>> fetchNews() async {
    final uri = Uri.https('content.guardianapis.com', '/search', {
      'section': categories.keys.join('|'),
      'show-fields': 'body,byline',
      'order-by': 'newest',
      'page-size': '30',
      'api-key': _apiKey,
    });
    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw http.ClientException('Status ${response.statusCode}');
    }

    final results = (jsonDecode(response.body)['response']['results'] as List)
        .cast<Map<String, dynamic>>();
    return [
      for (final json in results)
        NewsItem.fromGuardian(
          json,
          categories[json['sectionId']] ?? json['sectionName'] as String,
        ),
    ];
  }
}
