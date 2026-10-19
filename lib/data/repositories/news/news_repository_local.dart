import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../domain/models/news_item.dart';
import 'news_repository.dart';

/// Implementasi lokal in-memory dari NewsRepository.
/// Menjadi Single Source of Truth bagi HomeViewModel dan FavoriteViewModel
/// sehingga perubahan bookmark/favorit selalu sinkron di seluruh aplikasi.
class NewsRepositoryLocal extends ChangeNotifier implements NewsRepository {
  NewsRepositoryLocal({List<NewsItem>? initialNews})
    : _newsList =
          initialNews ??
          const [
            NewsItem(
              id: '1',
              category: 'Teknologi',
              timeAgo: '15 menit lalu',
              title: 'Inovasi Navigasi Suara untuk Disabilitas Netra Resmi Diluncurkan',
              durationText: '2 Menit',
              author: 'Tim Teknologi Gemanatra',
              content: 'Jakarta — Sebuah terobosan baru dalam teknologi asistif resmi diluncurkan hari ini untuk mendukung mobilitas rekan disabilitas netra dan low vision.\n\nSistem navigasi berbasis kecerdasan buatan dan sensor spasial ini mampu memberikan panduan suara real-time dengan akurasi tinggi di ruang terbuka maupun di dalam gedung.\n\nDalam uji coba di area transit publik, pengguna melaporkan peningkatan kepercayaan diri saat berjalan mandiri berkat respons audio yang jernih dan getaran haptic yang intuitif.',
              isFavorite: false,
            ),
            NewsItem(
              id: '2',
              category: 'Nasional',
              timeAgo: '1 jam lalu',
              title: 'Pemerintah Memperluas Fasilitas Guiding Block di Seluruh Stasiun Kereta',
              durationText: '3 Menit',
              author: 'Biro Komunikasi Publik',
              content: 'Kementerian Perhubungan mengumumkan perluasan jalur pemandu (guiding block) berstandar internasional di puluhan stasiun kereta api lintas antarkota dan komuter.\n\nLangkah ini bertujuan menciptakan ekosistem transportasi publik yang ramah disabilitas, aman, dan inklusif.\n\nSelain ubin pemandu bertekstur, pengumuman audio di peron juga diperbarui dengan kejelasan artikulasi yang lebih optimal bagi penumpang tunanetra.',
              isFavorite: true,
            ),
            NewsItem(
              id: '3',
              category: 'Kesehatan',
              timeAgo: '2 jam lalu',
              title: 'Kementerian Kesehatan Kenalkan Rekam Medis Berbantuan Suara untuk Pasien Low Vision',
              durationText: '4 Menit',
              author: 'Redaksi Kesehatan',
              content: 'Kementerian Kesehatan meluncurkan modul rekam medis berbantuan pembaca layar otomatis yang memudahkan pasien low vision mengakses resep dan anjuran dokter secara mandiri.\n\nFitur ini terintegrasi langsung dengan ponsel pintar pasien melalui kode respons cepat (QR Code) khusus yang dapat dipindai dengan panduan suara.',
              isFavorite: false,
            ),
            NewsItem(
              id: '4',
              category: 'Teknologi',
              timeAgo: 'Kemarin',
              title: 'Kacamata Pintar dengan Sensor Ultrasonik untuk Tunanetra Mulai Diuji Coba',
              durationText: '3 Menit',
              author: 'Laboratorium Inovasi Mandiri',
              content: 'Inovator muda Indonesia menguji coba prototipe kacamata pintar ringan yang dilengkapi detektor rintangan ultrasonik.\n\nAlat ini bekerja mendeteksi halangan setinggi kepala atau dada pengguna dan mengonversinya menjadi nada lembut di telinga tanpa menghalangi pendengaran sekitar.',
              isFavorite: true,
            ),
          ];

  List<NewsItem> _newsList;

  @override
  List<NewsItem> getAllNews() => UnmodifiableListView(_newsList);

  @override
  List<NewsItem> getFavoriteNews() =>
      UnmodifiableListView(_newsList.where((item) => item.isFavorite));

  @override
  NewsItem? getNewsById(String id) {
    try {
      return _newsList.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void toggleFavorite(String id) {
    var changed = false;
    _newsList = _newsList.map((item) {
      if (item.id == id) {
        changed = true;
        return item.copyWith(isFavorite: !item.isFavorite);
      }
      return item;
    }).toList();

    if (changed) {
      notifyListeners();
    }
  }

  @override
  void removeFavorite(String id) {
    var changed = false;
    _newsList = _newsList.map((item) {
      if (item.id == id && item.isFavorite) {
        changed = true;
        return item.copyWith(isFavorite: false);
      }
      return item;
    }).toList();

    if (changed) {
      notifyListeners();
    }
  }
}
