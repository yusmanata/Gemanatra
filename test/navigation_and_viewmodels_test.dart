import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gemanatra/data/repositories/news/news_repository_local.dart';
import 'package:gemanatra/main.dart';
import 'package:gemanatra/ui/favorite/view_models/favorite_viewmodel.dart';
import 'package:gemanatra/ui/home/view_models/home_viewmodel.dart';
import 'package:gemanatra/ui/main/view_models/main_navigation_viewmodel.dart';
import 'package:gemanatra/ui/news_detail/view_models/news_detail_viewmodel.dart';
import 'package:gemanatra/ui/settings/view_models/settings_viewmodel.dart';

void main() {
  group('MainNavigationViewModel Test', () {
    test('default tab adalah index 0 dan dapat berpindah', () {
      final vm = MainNavigationViewModel();
      expect(vm.currentIndex, 0);

      var notified = false;
      vm.addListener(() => notified = true);

      vm.selectTab(1);
      expect(vm.currentIndex, 1);
      expect(notified, isTrue);

      notified = false;
      vm.selectTab(1);
      expect(notified, isFalse);
    });
  });

  group('NewsRepository & ViewModel Synchronization Test', () {
    late NewsRepositoryLocal repository;
    late HomeViewModel homeVm;
    late FavoriteViewModel favoriteVm;

    setUp(() {
      repository = NewsRepositoryLocal();
      homeVm = HomeViewModel(repository: repository);
      favoriteVm = FavoriteViewModel(repository: repository);
    });

    tearDown(() {
      homeVm.dispose();
      favoriteVm.dispose();
      repository.dispose();
    });

    test(
      'HomeViewModel dan FavoriteViewModel tersinkronisasi via Repository',
      () {
        // 1. Cek data awal
        expect(homeVm.filteredNews.length, 4);
        final initialFavoriteCount = favoriteVm.count;
        expect(initialFavoriteCount, 2); // id 2 dan id 4 adalah favorit

        // 2. Tambah favorit dari Beranda (id 1)
        expect(favoriteVm.favorites.any((item) => item.id == '1'), isFalse);
        homeVm.toggleFavorite('1');

        // Harus otomatis muncul di tab Favorit
        expect(favoriteVm.count, initialFavoriteCount + 1);
        expect(favoriteVm.favorites.any((item) => item.id == '1'), isTrue);

        // 3. Hapus favorit dari tab Favorit (id 2)
        favoriteVm.removeFavorite('2');

        // Tanda favorit di Beranda untuk id 2 harus otomatis tercabut
        final news2InHome = homeVm.filteredNews.firstWhere(
          (item) => item.id == '2',
        );
        expect(news2InHome.isFavorite, isFalse);
      },
    );

    test('HomeViewModel memfilter berita berdasarkan kategori', () {
      homeVm.selectCategory(1); // Nasional
      expect(homeVm.selectedCategoryIndex, 1);
      for (final news in homeVm.filteredNews) {
        expect(news.category.toLowerCase(), 'nasional');
      }
    });
  });

  group('SettingsViewModel Test', () {
    test('dapat mengubah kecepatan bicara dan preferensi', () {
      final vm = SettingsViewModel();
      expect(vm.speechRate, 'Normal (1.0x)');

      vm.setSpeechRate('Cepat (1.25x)');
      expect(vm.speechRate, 'Cepat (1.25x)');

      vm.toggleAutoPlay(false);
      expect(vm.autoPlay, isFalse);

      vm.setSelectedCity('Bandung');
      expect(vm.selectedCity, 'Bandung');
    });
  });

  group('Widget Navigation Test', () {
    testWidgets('dapat berpindah antar tab BottomNavigationBar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const GemanatraApp());
      await tester.pumpAndSettle();

      // Cek halaman awal (Utama)
      expect(find.text('Gemanatra'), findsOneWidget);
      expect(find.text('CUACA HARI INI'), findsOneWidget);

      // Tap tab Favorit
      await tester.tap(find.text('Favorit'));
      await tester.pumpAndSettle();
      expect(find.text('Koleksi Berita Tersimpan'), findsOneWidget);

      // Tap tab Pengaturan
      await tester.tap(find.text('Pengaturan'));
      await tester.pumpAndSettle();
      expect(find.text('Aksesibilitas & Preferensi'), findsOneWidget);
      expect(find.text('Aksesibilitas Suara (TTS)'), findsOneWidget);
    });

    testWidgets(
      'layout aman saat layar diperkecil atau diperlebar tanpa overflow',
      (WidgetTester tester) async {
        // 1. Uji layar kecil / sempit (320x568 dp)
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const GemanatraApp());
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Buka Favorit di layar kecil
        await tester.tap(find.text('Favorit'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Buka Pengaturan di layar kecil
        await tester.tap(find.text('Pengaturan'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // 2. Uji layar lebar / tablet (1200x800 dp)
        tester.view.physicalSize = const Size(1200, 800);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // Kembali ke Utama di layar lebar
        await tester.tap(find.text('Utama'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'FavoriteScreen konten berada di atas layar (tidak di tengah secara vertikal)',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const GemanatraApp());
        await tester.pumpAndSettle();

        // Pindah ke tab Favorit
        await tester.tap(find.text('Favorit'));
        await tester.pumpAndSettle();

        // Temukan teks jumlah berita tersimpan
        final headerFinder = find.text('2 Berita Tersimpan');
        expect(headerFinder, findsOneWidget);

        // Ambil posisi Y dari teks tersebut
        final topPosition = tester.getTopLeft(headerFinder).dy;

        // Header harus berada di area atas (di bawah AppBar sekitar ~70-100dp),
        // bukan di tengah layar (> 250dp).
        expect(topPosition, lessThan(150.0));
      },
    );

    testWidgets(
      'Mengetuk kartu berita membuka NewsDetailScreen dan menampilkan isi lengkap',
      (WidgetTester tester) async {
        await tester.pumpWidget(const GemanatraApp());
        await tester.pumpAndSettle();

        // Cari kartu berita pertama
        final cardTitleFinder = find.text(
          'Inovasi Navigasi Suara untuk Disabilitas Netra Resmi Diluncurkan',
        );
        expect(cardTitleFinder, findsOneWidget);

        // Ketuk kartu berita
        await tester.tap(cardTitleFinder);
        await tester.pumpAndSettle();

        // Verifikasi kita berada di Halaman Detail Berita
        expect(find.text('Detail Berita'), findsOneWidget);
        expect(find.text('Dengarkan Versi Suara'), findsOneWidget);
        expect(find.textContaining('Tim Teknologi Gemanatra'), findsOneWidget);
        expect(
          find.textContaining('Sebuah terobosan baru dalam teknologi asistif'),
          findsOneWidget,
        );

        // Uji tombol putar suara narasi
        final playButton = find.text('Dengarkan Sekarang (2 Menit)');
        expect(playButton, findsOneWidget);
        await tester.tap(playButton);
        await tester.pumpAndSettle();
        expect(find.text('Sedang Membacakan Berita...'), findsOneWidget);

        // Uji tombol kembali
        await tester.tap(find.byTooltip('Kembali'));
        await tester.pumpAndSettle();

        // Kembali ke halaman utama
        expect(find.text('Gemanatra'), findsOneWidget);
      },
    );
  });

  group('NewsDetailViewModel Test', () {
    late NewsRepositoryLocal repository;
    late NewsDetailViewModel detailVm;

    setUp(() {
      repository = NewsRepositoryLocal();
      detailVm = NewsDetailViewModel(repository: repository, newsId: '1');
    });

    tearDown(() {
      detailVm.dispose();
      repository.dispose();
    });

    test('mengambil data berita dan status favorit dengan benar', () {
      expect(detailVm.news, isNotNull);
      expect(detailVm.news!.id, '1');
      expect(detailVm.isFavorite, isFalse);
      expect(detailVm.isPlayingVoice, isFalse);

      // Uji pemutaran suara asistif
      detailVm.toggleVoicePlayback();
      expect(detailVm.isPlayingVoice, isTrue);

      detailVm.toggleVoicePlayback();
      expect(detailVm.isPlayingVoice, isFalse);

      // Uji toggle favorit tersinkronisasi
      detailVm.toggleFavorite();
      expect(detailVm.isFavorite, isTrue);
      expect(repository.getNewsById('1')!.isFavorite, isTrue);
    });

    test('menangani id berita tidak valid dengan aman', () {
      final invalidVm = NewsDetailViewModel(
        repository: repository,
        newsId: 'nonexistent',
      );
      expect(invalidVm.news, isNull);
      expect(invalidVm.isFavorite, isFalse);
      invalidVm.dispose();
    });
  });
}
