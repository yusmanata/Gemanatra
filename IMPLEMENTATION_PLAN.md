# Implementation Plan: Gemanatra mengikuti arsitektur Senada

Referensi: https://github.com/spirinity/senada (dibaca di commit terbaru, 3.176 baris Dart, 0 package tambahan).

## 1. Analisis arsitektur Senada

### Struktur
```
lib/
├── main.dart                 # 3 baris: runApp(MyApp())
├── app/                      # "rangka" app: wiring saja, tanpa UI fitur
│   ├── app.dart              # MyApp (Stateful): buat semua controller global, dispose, MaterialApp
│   ├── app_scope.dart        # InheritedWidget penyedia controller global
│   ├── app_router.dart       # onGenerateRoute: nama route -> screen
│   ├── app_routes.dart       # konstanta nama route
│   └── main_shell.dart       # Scaffold + IndexedStack tab + bottom bar
├── core/                     # dipakai lintas fitur
│   ├── models/ data/ theme/ utils/ widgets/
└── features/<fitur>/
    ├── <fitur>_screen.dart
    ├── <fitur>_controller.dart   # hanya bila fitur punya state
    └── widgets/                  # widget khusus fitur itu
```
Tidak ada folder `data/repositories`, `view_models`, `domain`. Data contoh = konstanta di `core/data/`.

### Controller (inti pola)
- `XController extends ChangeNotifier`, field mutable **private**, getter publik **immutable** (`List.unmodifiable`), aksi = method biasa yang memanggil `notifyListeners()`. Tanpa `Result`, `Command`, atau abstract class.
- Dua jenis, dibedakan oleh **siapa yang butuh state itu**:

| Jenis | Contoh | Dibuat di | Diakses lewat |
|---|---|---|---|
| Global (dipakai banyak layar) | `PlayerController`, `FavoritesController`, `HistoryController` | `_MyAppState` | `AppScope.of(context).player` |
| Lokal (satu layar) | `ExploreController` (query pencarian), `TextEditingController`, `PageController` | `State` layar itu | field `_explore` |

- Controller global boleh bergantung pada controller lain lewat constructor (`PlayerController(history: _history)`), dirakit di `MyApp`.
- Dispose: pembuat yang bertanggung jawab. `MyApp` dispose semua global, `State` layar dispose yang lokal.

### AppScope
`InheritedWidget` murni pembawa controller, `updateShouldNotify => false` karena instance tidak pernah diganti. Perubahan nilai didengar lewat `ListenableBuilder`, bukan lewat InheritedWidget. Akses: `AppScope.of(context).favorites`.

### Stateless vs Stateful
- **StatelessWidget (default, mayoritas):** layar yang hanya membaca controller global (`FavoritesScreen`, `HistoryScreen`, `MiniPlayer`, `FavoriteButton`) dan semua sub-widget privat (`_Dashboard`, `_SectionTitle`, `_AlbumRow`).
- **StatefulWidget hanya bila:** (a) ada objek ber-lifecycle yang dibuat sendiri (`TextEditingController`, `PageController`, controller lokal), atau (b) state ephemeral (`_index` tab di `MainShell`).
- Tidak ada data hasil fetch disimpan di `State`.

### Rebuild
`ListenableBuilder(listenable: Listenable.merge([a, b]), builder: ...)` membungkus **isi layar**, satu tempat per layar. Widget kecil yang punya state sendiri (`FavoriteButton`) membuat `ListenableBuilder` sendiri sehingga hanya ia yang rebuild.

### Navigasi
`Navigator` bawaan + `onGenerateRoute` + `AppRoutes` (konstanta string). Tab = `IndexedStack` + `setState(_index)`. Tanpa go_router.

### Gaya kode
- Sub-widget = kelas privat `_Xxx`, bukan method `_buildXxx()`.
- Satu komentar `///` singkat per kelas/getter yang tidak jelas, berisi *alasan*.
- Pintasan sengaja diberi komentar `// shortcut: ...` (mis. progres disimulasikan Timer).
- `core/widgets/` berisi widget bersama (`SongTile`, `EmptyState`, `ScreenHeader`).

### Kelemahan Senada (jangan ditiru)
- Warna/ukuran font/padding masih hardcode di banyak screen (`fontSize: 15`, `EdgeInsets.fromLTRB(20, 6, 8, 6)`). Gemanatra sudah punya `Dimens` dan `AppColors`: **pertahankan**.
- Tanpa `Semantics`. Untuk tunanetra ini wajib di Gemanatra.
- `AppScope.of` memakai `!` tanpa pesan error.
- Tidak ada test, README kosong.

## 2. Kondisi Gemanatra sekarang (HEAD)
MVVM: 5 ViewModel (home 76, favorite 43, detail 52, settings 96, main-nav 16 baris), `NewsRepository` abstract + `NewsRepositoryLocal` (107), `main.dart` 89 baris merakit semua, `Navigator.push(MaterialPageRoute)` via callback `onNewsTap`. Test: `navigation_and_viewmodels_test.dart` (271 baris, menguji ViewModel) dan `widget_test.dart`.

## 3. Pemetaan Gemanatra -> pola Senada

| Sekarang | Menjadi | Alasan |
|---|---|---|
| `NewsRepository`(+Local), data berita | `core/data/sample_news.dart` (daftar `const`) + `NewsController` global | Berita + status favorit dipakai Home, Favorit, Detail -> global, seperti `FavoritesController`. Belum ada API, jadi repository belum perlu. |
| `HomeViewModel.filteredNews` | `NewsController.byCategory(String)` | Logika data di controller |
| `HomeViewModel._selectedCategoryIndex` | field `_selectedCategory` di `State` `HomeScreen` | State ephemeral satu layar |
| `HomeViewModel.weather` | `core/data/sample_weather.dart` (konstanta `WeatherSummary`) | Belum pakai API |
| `FavoriteViewModel` | dihapus. `FavoritesScreen` (Stateless) membaca `NewsController.favorites` | Favorit = turunan dari berita |
| `NewsDetailViewModel` | dihapus. `NewsDetailScreen` Stateful: `newsId` dari argumen route, `_isPlayingVoice` di `State` | Ephemeral; jadi controller global (`VoiceController`) saat TTS nyata dibuat |
| `SettingsViewModel` | `SettingsController` global di AppScope | TTS dan tema perlu membaca pengaturan dari layar lain |
| `MainNavigationViewModel` | `StatefulShellRoute.indexedStack` (go_router); `MainShell` Stateless menerima `navigationShell` | Indeks tab dikelola go_router, bukan `setState` |
| `main.dart` (89 baris) | `main.dart` ~40 baris: `GemanatraApp` (Stateful) membuat controller, `AppScope`, `MaterialApp.router`. **Tanpa `app.dart`.** | Sama seperti pengerjaan sebelumnya; wiring cukup satu file |
| `MaterialPageRoute` lewat callback `onNewsTap` | `GoRouter` di `app/app_router.dart`; detail = `/news/:id`, id dibaca dari `state.pathParameters['id']` dan dikirim ke screen lewat constructor | |

## 4. Struktur target
```
lib/
├── main.dart               # GemanatraApp (Stateful): NewsController, SettingsController, AppScope, MaterialApp.router
├── app/
│   ├── app_scope.dart
│   ├── app_router.dart     # GoRouter + StatefulShellRoute.indexedStack (Home, Favorit, Pengaturan) + route detail
│   ├── app_routes.dart     # home='/', favorites='/favorites', settings='/settings', newsDetail(id) -> '/news/$id'
│   └── main_shell.dart     # Scaffold + navigationShell + nav bar
├── core/
│   ├── models/             # news_item.dart, weather_summary.dart (dipindah, tetap immutable + copyWith)
│   ├── data/               # sample_news.dart, sample_weather.dart
│   ├── theme/              # app_theme.dart, app_colors.dart, dimens.dart (dipindah dari ui/core/themes)
│   └── widgets/            # app_status_badge.dart, gemanatra_app_bar.dart (dipindah dari ui/core/ui)
└── features/
    ├── home/        home_screen.dart (Stateful: kategori, ScrollController bila ada) + widgets/{category_chips,news_card,weather_card}.dart
    ├── favorites/   favorites_screen.dart (Stateless) + widgets/favorite_empty_view.dart
    ├── news_detail/ news_detail_screen.dart (Stateful) + (pecah 367 baris jadi widgets/ privat/terpisah)
    ├── settings/    settings_screen.dart + settings_controller.dart + widgets/{setting_section,setting_tile}.dart
    └── (controller global) news/news_controller.dart
```
Catatan penempatan: `NewsController` diletakkan di `features/news/` mengikuti `features/player/player_controller.dart` Senada (controller global tinggal di folder fiturnya).

## 5. Langkah kerja (urut, tiap langkah harus lulus `flutter analyze`)

1. **Tambah `go_router` ke pubspec** (`flutter pub add go_router`; izin sudah Anda berikan).
1b. **Tulis ulang `AGENTS.md`** sesuai bagian 1 (aturan: controller `ChangeNotifier` + `AppScope` + `ListenableBuilder`, go_router, Stateless default, struktur folder, anti-pola, aksesibilitas). Hapus keputusan lama MVVM/provider; go_router tetap. *Menunggu persetujuan Anda, karena Anda yang memutuskan aturan.*
2. **Pindah folder tanpa ubah isi:** `domain/models` -> `core/models`, `ui/core/themes` -> `core/theme`, `ui/core/ui` -> `core/widgets`, `ui/<fitur>/widgets` -> `features/<fitur>`. Perbaiki import. (Pakai `git mv` supaya riwayat terjaga.)
3. **Data contoh:** pindahkan daftar berita dari `NewsRepositoryLocal` ke `core/data/sample_news.dart`; cuaca ke `sample_weather.dart`.
4. **`NewsController`:** `news`, `favorites`, `byCategory`, `findById`, `toggleFavorite`. Hapus `NewsRepository*`.
5. **`SettingsController`:** salin isi `SettingsViewModel`, ganti nama, tanpa perubahan logika.
6. **`app/` + `main.dart`:** `AppScope`, `AppRoutes`, `AppRouter` (GoRouter), `MainShell`; `GemanatraApp` ditaruh di `main.dart`. Tambahkan pesan error pada `AppScope.of` (tidak memakai `!`).
7. **Ubah layar satu per satu** (Settings -> Favorit -> Home -> Detail): hapus parameter `viewModel`/`onNewsTap`, ambil controller dari `AppScope`, bungkus isi dengan `ListenableBuilder`. Tap berita memanggil `context.push(AppRoutes.newsDetail(id))`; tab diganti lewat `navigationShell.goBranch`.
8. **Hapus** semua `view_models/`, `news_repository*`, `main_navigation_screen.dart`.
9. **Test:** tidak dibuat (keputusan Anda). Hapus `test/navigation_and_viewmodels_test.dart` karena menguji ViewModel yang dihapus; `widget_test.dart` disesuaikan agar tetap compile atau dihapus.
10. **Verifikasi:** `dart format .`, `flutter analyze`, jalankan app sekali. **Tidak ada commit**; semua perubahan dibiarkan di working tree untuk Anda review.
11. **Aksesibilitas (terpisah, setelah pola selesai):** `Semantics` label di kartu berita, tombol suara, chip kategori; kontras tinggi dari `SettingsController`. Tidak dikerjakan di refactor ini agar diff tetap bisa dibaca.

## 6. Yang sengaja tidak dilakukan
- Satu-satunya package baru: `go_router`. Tanpa provider/freezed.
- Tidak ada repository/service/`Result` sampai API nyata ada. Saat itu: buat `NewsService` di `core/` atau `features/news/` dan panggil dari `NewsController`, tanpa lapisan baru lain.
- `VoiceController` (TTS) belum dibuat; hanya `_isPlayingVoice` di State detail dengan komentar `// shortcut:`.

## 7. Risiko
- Tanpa test, regresi pada favorit/navigasi tidak tertangkap otomatis; verifikasi hanya `flutter analyze` + uji manual.
- Langkah 2 mengubah path semua import, jadi kerjakan dalam satu commit terpisah agar mudah di-revert.
- Hilangnya abstract repository berarti saat API datang, `NewsController` yang diubah (bukan sekadar menukar implementasi). Itu pilihan sadar demi kesederhanaan.
- `StatefulWidget` untuk `HomeScreen` hanya demi satu field kategori. Alternatif: taruh `selectedCategory` di `NewsController` (Home jadi Stateless), tapi state filter ikut global. Rekomendasi: tetap di `State`.
