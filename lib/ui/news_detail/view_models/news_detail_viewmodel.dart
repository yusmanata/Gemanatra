import 'package:flutter/foundation.dart';

import '../../../data/repositories/news/news_repository.dart';
import '../../../domain/models/news_item.dart';

/// ViewModel untuk halaman Detail Berita.
/// Mengelola status pemutaran suara asistif (TTS) dan sinkronisasi bookmark
/// dengan NewsRepository sebagai Single Source of Truth.
class NewsDetailViewModel extends ChangeNotifier {
  NewsDetailViewModel({
    required NewsRepository repository,
    required String newsId,
  }) : _newsRepository = repository,
       _selectedNewsId = newsId {
    _newsRepository.addListener(_onRepositoryUpdated);
  }

  final NewsRepository _newsRepository;
  final String _selectedNewsId;

  bool _isPlayingVoice = false;

  /// Status apakah suara pembacaan berita sedang aktif.
  bool get isPlayingVoice => _isPlayingVoice;

  /// Data artikel berita saat ini yang diambil dari repository.
  NewsItem? get news => _newsRepository.getNewsById(_selectedNewsId);

  /// Status apakah berita ini ditandai sebagai favorit.
  bool get isFavorite => news?.isFavorite ?? false;

  /// Membalikkan status simpan/favorit pada repository.
  void toggleFavorite() {
    _newsRepository.toggleFavorite(_selectedNewsId);
  }

  /// Memutar atau menghentikan pembacaan audio narasi berita.
  void toggleVoicePlayback() {
    _isPlayingVoice = !_isPlayingVoice;
    notifyListeners();
  }

  void _onRepositoryUpdated() {
    notifyListeners();
  }

  @override
  void dispose() {
    _newsRepository.removeListener(_onRepositoryUpdated);
    super.dispose();
  }
}
