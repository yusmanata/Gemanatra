import 'package:flutter_test/flutter_test.dart';
import 'package:gemanatra/domain/models/news_item.dart';
import 'package:gemanatra/main.dart';
import 'package:gemanatra/ui/favorite/view_models/favorite_viewmodel.dart';
import 'package:gemanatra/ui/home/view_models/home_viewmodel.dart';
import 'package:gemanatra/ui/main/view_models/main_navigation_viewmodel.dart';
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

      // memilih tab yang sama tidak memicu notification ulang
      notified = false;
      vm.selectTab(1);
      expect(notified, isFalse);
    });
  });

  group('HomeViewModel Test', () {
    test('memiliki data awal cuaca dan kategori', () {
      final vm = HomeViewModel();
      expect(vm.weather.location, 'DKI Jakarta');
      expect(vm.categories.length, greaterThan(0));
      expect(vm.selectedCategoryIndex, 0);
      expect(vm.filteredNews.length, greaterThan(0));
    });

    test('dapat memfilter berita berdasarkan kategori', () {
      final vm = HomeViewModel();
      vm.selectCategory(1); // Nasional
      expect(vm.selectedCategoryIndex, 1);
      for (final news in vm.filteredNews) {
        expect(news.category.toLowerCase(), 'nasional');
      }
    });

    test('dapat mengubah status bookmark favorit berita', () {
      final vm = HomeViewModel();
      final initialFavorite = vm.filteredNews.first.isFavorite;
      final targetId = vm.filteredNews.first.id;

      vm.toggleFavorite(targetId);
      final updated = vm.filteredNews.firstWhere((n) => n.id == targetId);
      expect(updated.isFavorite, !initialFavorite);
    });
  });

  group('FavoriteViewModel Test', () {
    test('dapat menghapus dan menambahkan berita favorit', () {
      final vm = FavoriteViewModel();
      final initialCount = vm.count;
      expect(initialCount, greaterThan(0));

      final firstId = vm.favorites.first.id;
      vm.removeFavorite(firstId);
      expect(vm.count, initialCount - 1);
      expect(vm.favorites.any((n) => n.id == firstId), isFalse);

      vm.addFavorite(
        const NewsItem(
          id: '99',
          category: 'Umum',
          title: 'Berita Baru',
          timeAgo: 'Baru saja',
          durationText: '1 Menit',
        ),
      );
      expect(vm.favorites.any((n) => n.id == '99'), isTrue);
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
  });
}
