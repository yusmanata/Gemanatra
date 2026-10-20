# Panduan Belajar Gemanatra (untuk UTS dan live coding)

Panduan ini ditulis dari kode yang ada sekarang. Setiap contoh menyebut file aslinya, jadi bisa dibuka dan dicoba langsung.

Daftar isi:
1. Gambaran besar dan alur startup
2. Penjelasan per file dan alur data per fitur
3. Dasar Flutter yang paling sering dipakai
4. Pertanyaan teori yang mungkin keluar
5. Latihan live coding (soal dan jawaban)
6. Urutan belajar dan checklist

---

## 1. Gambaran besar

Gemanatra adalah aplikasi berita dan cuaca bersuara untuk tunanetra dan low vision. Ada 3 tab (Utama, Favorit, Pengaturan) dan 1 halaman detail berita. Belum ada API dan belum ada suara asli. Data berita dan cuaca berupa konstanta.

### Struktur folder
```
lib/
├── main.dart                  # titik masuk + merakit aplikasi
├── app/router.dart            # daftar halaman dan path (go_router)
├── core/                      # dipakai banyak fitur
│   ├── app_scope.dart         # "kotak" pembawa controller ke semua layar
│   ├── data/                  # data contoh (sample_news, sample_weather)
│   ├── models/                # bentuk data (NewsItem, WeatherSummary)
│   ├── theme/                 # warna, ukuran, gaya teks (app_colors, dimens, app_theme)
│   └── widgets/               # widget bersama (GemanatraAppBar, AppStatusBadge)
└── features/                  # satu folder per fitur
    ├── main/        main_shell.dart
    ├── home/        home_screen.dart + widgets/(weather_card, category_chips, news_card)
    ├── favorites/   favorites_screen.dart + widgets/favorite_empty_view.dart
    ├── news_detail/ news_detail_screen.dart
    ├── settings/    settings_screen.dart, settings_controller.dart + widgets/(setting_section, setting_tile)
    └── news/        news_controller.dart
```
Aturan penempatan: dipakai satu fitur, taruh di folder fitur itu. Dipakai banyak fitur, taruh di `core/`.

### Tiga ide inti arsitektur
1. **Controller** = kelas yang menyimpan data dan aksi (`extends ChangeNotifier`). Saat data berubah, ia memanggil `notifyListeners()`.
2. **AppScope** = `InheritedWidget` yang membawa controller dari atas pohon widget ke semua layar. Cara ambil: `AppScope.of(context).news`.
3. **ListenableBuilder** = widget yang membangun ulang tampilannya setiap controller memanggil `notifyListeners()`.

Rumus alurnya:
```
Aksi pengguna -> method controller -> data berubah -> notifyListeners()
   -> ListenableBuilder rebuild -> tampilan baru
```

### Alur startup
```
main() -> runApp(GemanatraApp)
  _GemanatraAppState membuat: NewsController, SettingsController, GoRouter
  build(): AppScope( news, settings, child: MaterialApp.router(routerConfig: router) )
  GoRouter membuka path '/' -> MainShell(tab Home) -> HomeScreen
```

---

## 2. Penjelasan per file

### 2.1 `lib/main.dart`
- `main()` hanya memanggil `runApp(const GemanatraApp())`.
- `GemanatraApp` adalah **StatefulWidget** karena ia membuat objek yang harus dibuang saat selesai (controller dan router).
- Di `_GemanatraAppState`:
  - `final _news = NewsController();` dan `final _settings = SettingsController();` dibuat **sekali**.
  - `late final GoRouter _router = createRouter();` dibuat sekali (`late` = baru dibuat saat pertama dipakai).
  - `dispose()` membuang ketiganya supaya tidak bocor memori.
  - `build()` membungkus `MaterialApp.router` dengan `AppScope`, sehingga semua layar di bawahnya bisa mengakses controller.
- `theme: AppTheme.lightTheme` memberi tema (warna, font, gaya tombol) ke seluruh aplikasi.

### 2.2 `lib/core/app_scope.dart`
- `AppScope extends InheritedWidget`. Isinya hanya dua field: `news` dan `settings`.
- `AppScope.of(context)` mencari AppScope terdekat di atas widget lewat `getInheritedWidgetOfExactType`. Ada `assert` agar error jelas jika lupa memasangnya.
- `updateShouldNotify => false` artinya AppScope tidak memicu rebuild sendiri. Yang memicu rebuild adalah `ListenableBuilder` pada controller. Alasannya: objek controller tidak pernah diganti, hanya isinya yang berubah.

### 2.3 `lib/app/router.dart`
- `AppRoutes` = kumpulan path supaya tidak menulis string di banyak tempat: `home '/'`, `favorites '/favorites'`, `settings '/settings'`, `newsDetail(id) => '/news/$id'`.
- `createRouter()` membuat `GoRouter` berisi:
  - `StatefulShellRoute.indexedStack` dengan 3 `StatefulShellBranch` (satu per tab). `indexedStack` menjaga state tiap tab saat berpindah (posisi scroll dan kategori terpilih tidak hilang).
  - `GoRoute(path: '/news/:id')` di luar shell, jadi halaman detail menutupi seluruh layar termasuk bottom bar. `:id` dibaca dengan `state.pathParameters['id']`.

### 2.4 `lib/features/main/main_shell.dart` (Stateless)
- Menerima `navigationShell` dari go_router. Dialah isi tab aktif, dipasang sebagai `body`.
- `BottomNavigationBar`: `currentIndex` dari `navigationShell.currentIndex`. Saat diketuk: `navigationShell.goBranch(index, initialLocation: index == currentIndex)`. `initialLocation: true` berarti mengetuk tab yang sedang aktif akan kembali ke halaman awal tab itu.
- Tidak ada `setState` dan tidak perlu StatefulWidget, karena indeks tab dikelola go_router.

### 2.5 `lib/core/models/news_item.dart` dan `weather_summary.dart`
- Model = bentuk data. Semua field `final` (immutable), constructor `const`.
- `copyWith` membuat salinan dengan sebagian field diganti. Dipakai untuk mengubah `isFavorite` tanpa memodifikasi objek lama.
- Mengapa immutable? Perubahan selalu berupa objek baru, jadi mudah dilacak dan aman dibagi ke banyak layar.

### 2.6 `lib/core/data/sample_news.dart` dan `sample_weather.dart`
- Konstanta `sampleNews` (4 berita) dan `sampleWeather`. Menggantikan API untuk sementara. Saat API ada, `NewsController` yang berubah, layar tidak.

### 2.7 `lib/features/news/news_controller.dart`
Sumber tunggal data berita.
| Anggota | Fungsi |
|---|---|
| `_news` | daftar berita (private) |
| `news` | getter salinan tak bisa diubah (`List.unmodifiable`) |
| `favorites` | berita dengan `isFavorite == true` |
| `byCategory(c)` | filter kategori, tidak peka huruf besar |
| `findById(id)` | cari satu berita, `null` bila tidak ada |
| `toggleFavorite(id)` | balik status favorit, lalu `notifyListeners()` |

`toggleFavorite` membuat **list baru** (`[for (...) if (...) copyWith(...) else item]`) lalu memberi tahu pendengar.

### 2.8 `lib/features/settings/settings_controller.dart`
- Menyimpan pengaturan: `speechRate`, `autoPlay`, `speechPitch`, `highContrast`, `textSize`, `selectedCity`, plus daftar pilihan (`availableSpeechRates`, dst).
- Tiap setter (`setSpeechRate`, `toggleAutoPlay`, ...) cek dulu apakah nilainya sama (`if (_x == value) return;`). Kalau beda, simpan lalu `notifyListeners()`. Pengecekan ini mencegah rebuild yang sia-sia.
- Catatan jujur: pengaturan ini baru mengubah tampilan di layar Pengaturan. Belum ada fitur lain yang membacanya.

### 2.9 `lib/features/home/home_screen.dart` (Stateful)
- Stateful karena menyimpan `int _selectedCategory` (state ephemeral: hanya milik layar ini, boleh reset).
- `_categories` adalah daftar tetap (`static const`).
- `build`:
  1. Ambil `news` dari `AppScope`.
  2. `ListenableBuilder(listenable: news, ...)` membungkus isi layar.
  3. Di dalamnya hitung `filteredNews`: kalau kategori 0 ("Semua") pakai `news.news`, kalau tidak `news.byCategory(...)`.
  4. `SingleChildScrollView` + `Column` berisi `WeatherCard`, `CategoryChips`, judul, lalu daftar `NewsCard` lewat `for (final item in filteredNews) ...[ ... ]`.
- Struktur luar `Scaffold > SafeArea > Align > ConstrainedBox(maxWidth)` membuat konten tidak melebar berlebihan di layar lebar.
- Alur:
  - **Ganti kategori:** chip diketuk -> `setState(() => _selectedCategory = index)` -> HomeScreen rebuild -> daftar baru.
  - **Simpan favorit:** ikon bookmark -> `news.toggleFavorite(id)` -> controller `notifyListeners()` -> semua `ListenableBuilder` pada `news` rebuild (Home, Favorit, Detail).
  - **Buka detail:** kartu diketuk -> `context.push(AppRoutes.newsDetail(item.id))`.
  - **Tombol suara:** `_playWeatherVoice` dan `_playNewsVoice` masih kosong (ditandai `shortcut`).

### 2.10 `lib/features/home/widgets/`
- `weather_card.dart` (Stateless): menerima `WeatherSummary` dan callback `onListenPressed`. Memakai `Row`, `Column`, `Expanded` (teks kondisi tidak meluap), `Flexible` (nama lokasi bisa dipotong `ellipsis`), `Semantics(label: ...)` untuk pembaca layar.
- `category_chips.dart` (Stateless): `SingleChildScrollView(scrollDirection: Axis.horizontal)` + `Row` berisi `ChoiceChip` hasil `List.generate`. Widget ini tidak menyimpan state; ia hanya menerima `selectedIndex` dan memanggil `onSelected(index)`. Ini pola **lifting state up**: state ada di induk (HomeScreen).
- `news_card.dart` (Stateless): `Card > InkWell > Padding > Column`. Baris atas berisi kategori, waktu, dan tombol bookmark. Callback `onListen`, `onFavoriteToggle`, `onTap` diberikan induk. Widget ini tidak tahu apa pun soal controller, jadi bisa dipakai di Home dan Favorit.

### 2.11 `lib/features/favorites/favorites_screen.dart` (Stateless)
- Tidak punya state sendiri. Semua dari `news.favorites`.
- Di dalam `ListenableBuilder`: kalau kosong tampilkan `FavoriteEmptyView`, kalau ada tampilkan judul "N Berita Tersimpan" + daftar `NewsCard`.
- Menekan bookmark di sini memanggil `news.toggleFavorite(id)`, sehingga kartu hilang dari daftar (karena `isFavorite` jadi false).
- Urutan penanganan state: **kosong -> isi**.

### 2.12 `lib/features/news_detail/news_detail_screen.dart` (Stateful)
- Menerima `newsId` dari router lewat constructor.
- State lokal: `bool _isPlayingVoice` (tombol putar/henti; belum ada suara asli).
- `build`: `ListenableBuilder` pada `news` -> `controller.findById(widget.newsId)`.
  - `news == null` -> `_NewsNotFoundView`.
  - Ada -> `_NewsDetailContent` (banner suara, header artikel, paragraf).
- Sub-widget privat: `_NewsDetailContent`, `_AudioPlaybackBanner`, `_ArticleHeaderSection`, `_ArticleParagraphs`, `_NewsNotFoundView`. Pola ini (kelas kecil, bukan method `_buildXxx`) dipakai agar `build` tidak panjang.
- Isi artikel dipecah per paragraf dengan `content.split('\n\n')`.
- Tombol bookmark di AppBar memanggil `controller.toggleFavorite(news.id)`, dan ikon langsung berubah karena ada di dalam `ListenableBuilder`.

### 2.13 `lib/features/settings/` (Stateless + widget pendukung)
- `settings_screen.dart`: ambil `settings` dari `AppScope`, `ListenableBuilder`, lalu 4 `SettingSection`. Kontrol: `DropdownButton<String>` (kecepatan, ukuran teks, kota) dan `Switch` (putar otomatis, kontras tinggi).
- Alur `DropdownButton`: `onChanged: (value) { if (value != null) settings.setSpeechRate(value); }` -> controller menyimpan -> rebuild -> dropdown menampilkan nilai baru.
- `setting_section.dart`: judul seksi + `Card` berisi daftar anak yang dipisah `Divider`.
- `setting_tile.dart`: satu baris pengaturan. `Row` dengan `Expanded(flex: 3)` untuk teks dan `Flexible(flex: 2)` untuk kontrol di kanan, `ConstrainedBox(minHeight: 48)` supaya target sentuh nyaman.

### 2.14 `lib/core/theme/`
- `app_colors.dart`: kumpulan warna `static const Color`. Ganti di sini, seluruh app ikut berubah.
- `dimens.dart`: ukuran spasi, ikon, radius, padding. `Dimens.of(context)` memilih ukuran sesuai lebar layar (`MediaQuery.sizeOf(context).width`, lebar > 600 dianggap layar besar).
- `app_theme.dart`: `ThemeData` Material 3. Mengatur `colorScheme`, `textTheme` (displayLarge, titleLarge, titleMedium, titleSmall, bodyLarge, bodyMedium, labelMedium, labelSmall), `appBarTheme`, `elevatedButtonTheme` (tinggi tombol dari `Dimens.buttonHeight`), `chipTheme`, `bottomNavigationBarTheme`.
- Cara pakai di widget: `Theme.of(context).textTheme.titleMedium`, `AppColors.primary`, `Dimens.of(context).spacingLarge`.

### 2.15 `lib/core/widgets/`
- `gemanatra_app_bar.dart`: AppBar kustom yang `implements PreferredSizeWidget` (wajib punya `preferredSize` agar bisa dipakai sebagai `appBar:` di Scaffold). Isi: logo + judul + subjudul + badge TTS.
- `app_status_badge.dart`: badge kecil "TTS AKTIF" memakai `Container` + `BoxDecoration` + `Row(mainAxisSize: min)`.

---

## 3. Dasar Flutter yang sering dipakai

### 3.1 Semua adalah widget
UI = pohon widget. Widget kecil disusun menjadi layar. Ada dua jenis:
- **StatelessWidget**: tampilan hanya bergantung pada input (constructor). Pakai sebagai default.
- **StatefulWidget**: punya data yang berubah dan disimpan di `State`. Ubah dengan `setState(() { ... })`.

Kapan Stateful? Hanya jika (1) ada state sementara milik satu layar (tab terpilih, kategori, toggle), atau (2) butuh `initState`/`dispose` (controller, listener).

```dart
class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() => _count++),
      child: Text('Diketuk $_count kali'),
    );
  }
}
```

### 3.2 Row dan Column (paling penting)
`Row` menyusun ke samping, `Column` ke bawah.
- **Sumbu utama** (main axis): Row = horizontal, Column = vertikal. Diatur `mainAxisAlignment`.
- **Sumbu silang** (cross axis): sebaliknya. Diatur `crossAxisAlignment`.

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween, // kiri dan kanan
  crossAxisAlignment: CrossAxisAlignment.center,     // rata tengah vertikal
  children: [Text('Kiri'), Icon(Icons.star)],
)

Column(
  crossAxisAlignment: CrossAxisAlignment.start,      // rata kiri
  children: [Text('Judul'), Text('Subjudul')],
)
```
Nilai `mainAxisAlignment`: `start`, `center`, `end`, `spaceBetween`, `spaceAround`, `spaceEvenly`.
`mainAxisSize: MainAxisSize.min` membuat Row/Column hanya sebesar isinya (dipakai di `AppStatusBadge`).

### 3.3 Expanded dan Flexible (mengatasi teks meluap)
Error "RenderFlex overflowed" biasanya karena teks panjang di dalam `Row`. Perbaikan: bungkus dengan `Expanded`.
```dart
Row(children: [
  Icon(Icons.article),
  SizedBox(width: 8),
  Expanded(child: Text(judulPanjang, maxLines: 2, overflow: TextOverflow.ellipsis)),
])
```
- `Expanded` = ambil seluruh sisa ruang.
- `Flexible` = boleh mengecil, tidak dipaksa memenuhi (dipakai untuk nama lokasi di `WeatherCard`).
- `flex: 3` dan `flex: 2` membagi ruang 3:2 (lihat `SettingTile`).
- `Expanded` hanya boleh langsung di dalam `Row`, `Column`, atau `Flex`.

### 3.4 ConstrainedBox, SizedBox, Padding, Align, Center, Container
```dart
// Batas ukuran. Dipakai di HomeScreen agar konten maksimal 720 lebar.
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 720, minHeight: 48),
  child: ...,
)

SizedBox(width: 8)                        // jarak kosong
SizedBox(height: 48, width: double.infinity, child: tombol)  // paksa ukuran

Padding(padding: EdgeInsets.all(16), child: ...)
Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: ...)
Padding(padding: EdgeInsets.only(right: 8), child: ...)
Padding(padding: EdgeInsets.fromLTRB(20, 4, 20, 12), child: ...)

Center(child: ...)                                 // tengah
Align(alignment: Alignment.topCenter, child: ...)  // posisi bebas

Container(                                         // kotak dengan dekorasi
  padding: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.amber,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey),
  ),
  child: Text('Isi'),
)
```
Aturan hemat: kalau hanya butuh jarak pakai `Padding`/`SizedBox`, jangan `Container`.

`ConstrainedBox` vs `SizedBox`: SizedBox menetapkan ukuran **pasti**. ConstrainedBox menetapkan **batas** (min/max), anaknya bebas di dalam batas itu.

### 3.5 Stack dan Positioned (tumpuk widget)
```dart
Stack(
  children: [
    Image.asset('assets/images/logo.jpg'),
    Positioned(top: 8, right: 8, child: Icon(Icons.bookmark)),
  ],
)
```
`Positioned` hanya boleh di dalam `Stack`.

### 3.6 Scroll
```dart
// Konten sedikit tapi bisa melebihi layar (dipakai di Home, Favorit, Pengaturan).
SingleChildScrollView(child: Column(children: [...]))

// Daftar panjang. Item dibuat saat terlihat saja.
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, i) => ListTile(title: Text(items[i].title)),
)

// ListView di dalam Column WAJIB dibatasi tinggi.
Column(children: [
  Text('Judul'),
  Expanded(child: ListView.builder(...)),
])
```
Error "Vertical viewport was given unbounded height" = ListView di Column tanpa `Expanded`.

### 3.7 Text, Icon, Image, tombol
```dart
Text('Halo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
     maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)

Text('Judul', style: Theme.of(context).textTheme.titleMedium)   // cara di proyek ini
Text('Ubah', style: textTheme.titleMedium?.copyWith(color: Colors.red)) // ubah sebagian

Icon(Icons.home, size: 24, color: AppColors.primary)
Image.asset('assets/images/logo.jpg', width: 36, height: 36, fit: BoxFit.cover)

ElevatedButton(onPressed: () {}, child: Text('Simpan'))
ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.headphones), label: Text('Dengar'))
TextButton(onPressed: () {}, child: Text('Batal'))
IconButton(onPressed: () {}, icon: Icon(Icons.bookmark), tooltip: 'Simpan')
```
`onPressed: null` membuat tombol nonaktif.
Gambar dari asset harus didaftarkan di `pubspec.yaml` bagian `flutter: assets:`.

### 3.8 Menjadikan widget bisa diketuk
```dart
InkWell(onTap: () {}, child: ...)            // ada efek ripple, dipakai di NewsCard
GestureDetector(onTap: () {}, child: ...)    // tanpa efek visual
```

### 3.9 Scaffold, AppBar, SafeArea, Card
```dart
Scaffold(
  appBar: AppBar(title: Text('Judul')),
  body: SafeArea(child: ...),          // hindari notch dan status bar
  bottomNavigationBar: BottomNavigationBar(...),
  floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
)
Card(child: Padding(padding: EdgeInsets.all(16), child: ...))
```

### 3.10 Input: TextField dan Switch
`TextEditingController` wajib dibuat di `State` dan di-`dispose`.
```dart
class _SearchState extends State<Search> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();   // wajib, kalau tidak bocor memori
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(hintText: 'Cari berita', prefixIcon: Icon(Icons.search)),
      onChanged: (text) => setState(() {}),
    );
  }
}

Switch(value: aktif, onChanged: (v) => setState(() => aktif = v))
```
TextField di dalam Row harus dibungkus `Expanded`.

### 3.11 Kondisi dan perulangan di dalam daftar widget
```dart
children: [
  if (isEmpty) Text('Kosong'),                       // if tunggal
  isFavorite ? Icon(Icons.star) : Icon(Icons.star_border),  // ternary
  for (final item in items) Text(item.title),        // for
  for (final item in items) ...[                     // spread: banyak widget per item
    NewsCard(news: item),
    SizedBox(height: 12),
  ],
]
```

### 3.12 Ukuran, tema, dan MediaQuery
```dart
final width = MediaQuery.sizeOf(context).width;     // lebar layar
final dimens = Dimens.of(context);
final textTheme = Theme.of(context).textTheme;
```
Aturan proyek ini: warna dari `AppColors`, ukuran dari `Dimens`, gaya teks dari `textTheme`. Jangan menulis angka dan warna langsung di widget fitur. Untuk soal live coding yang meminta "ubah cepat", menulis langsung diperbolehkan, tapi tahu lokasi yang benar.

### 3.13 Navigasi dengan go_router
```dart
context.push('/news/3');             // buka halaman di atas yang sekarang (bisa kembali)
context.go('/favorites');            // pindah, ganti tumpukan
Navigator.of(context).maybePop();    // kembali (dipakai tombol Kembali)
```
Mendaftar halaman baru: tambahkan `GoRoute(path: '/about', builder: (context, state) => const AboutScreen())` di `createRouter()`.

### 3.14 Async dasar (untuk pembelajaran lanjutan)
```dart
Future<String> ambilData() async {
  await Future.delayed(Duration(seconds: 1));
  return 'selesai';
}
```
Proyek ini belum memakai API, tapi `Future`, `async`, `await` sangat mungkin keluar. Saat API ada, `FutureBuilder` atau controller akan dipakai.

### 3.15 Semantics (aksesibilitas)
```dart
Semantics(label: 'Simpan ke favorit', button: true, child: IconButton(...))
Semantics(header: true, child: Text('Berita Utama'))
```
Pembaca layar (TalkBack) membacakan `label`. `tooltip` pada `IconButton` juga dibacakan. Ini ciri khas Gemanatra.

---

## 4. Pertanyaan teori yang mungkin keluar

Jawaban singkat ditulis di bawah tiap soal.

1. **Apa beda StatelessWidget dan StatefulWidget?**
   Stateless tidak punya data yang berubah dari dalam. Stateful menyimpan data di `State` dan memakai `setState` untuk memicu rebuild.
2. **Apa fungsi `setState`?** Memberi tahu Flutter bahwa data berubah, lalu memanggil `build` ulang widget itu.
3. **Mengapa `HomeScreen` Stateful tetapi `FavoritesScreen` Stateless?**
   Home menyimpan `_selectedCategory`. Favorit tidak punya state sendiri, datanya dari `NewsController`.
4. **Apa itu `ChangeNotifier` dan `notifyListeners()`?**
   Kelas yang bisa didengarkan. `notifyListeners()` memanggil semua pendengar, termasuk `ListenableBuilder`, untuk rebuild.
5. **Apa fungsi `ListenableBuilder`?** Membangun ulang bagian UI saat `listenable` (controller) memberi sinyal.
6. **Apa itu `InheritedWidget` dan mengapa memakai `AppScope`?**
   Widget yang membagikan data ke turunannya tanpa mengoper lewat constructor satu per satu. `AppScope` membawa controller ke semua layar.
7. **Mengapa `updateShouldNotify` bernilai `false`?** Instance controller tidak pernah diganti, perubahan datanya didengar lewat `ListenableBuilder`.
8. **Mengapa controller harus di-`dispose`?** Melepas listener, timer, dan sumber daya agar tidak bocor memori. Siapa yang membuat, dia yang membuang.
9. **Apa itu lifting state up?** Memindahkan state ke induk bersama agar bisa dipakai beberapa anak. Contoh: kategori terpilih ada di `HomeScreen`, `CategoryChips` hanya menerima nilainya dan callback.
10. **Mengapa model dibuat immutable dan memakai `copyWith`?** Perubahan = objek baru, lebih aman dan mudah dilacak. `toggleFavorite` membuat list baru.
11. **Beda `Expanded` dan `Flexible`?** Expanded memaksa mengisi sisa ruang. Flexible boleh lebih kecil dari ruang yang tersedia.
12. **Apa penyebab "RenderFlex overflowed" dan perbaikannya?** Anak Row/Column lebih besar dari ruang. Bungkus dengan `Expanded`, pakai `ellipsis`, atau buat scrollable.
13. **Beda `Container`, `SizedBox`, dan `Padding`?** Container serbaguna (dekorasi + ukuran + padding). SizedBox hanya ukuran. Padding hanya jarak. Pakai yang paling sederhana.
14. **Beda `ListView` dan `ListView.builder`?** Builder membuat item hanya saat terlihat, cocok untuk daftar panjang atau dinamis.
15. **Beda `context.push` dan `context.go`?** Push menumpuk halaman (bisa kembali). Go mengganti lokasi dan tumpukan mengikuti path.
16. **Apa fungsi `StatefulShellRoute.indexedStack`?** Navigasi tab yang menjaga state tiap tab.
17. **Mengapa halaman detail ada di luar shell?** Supaya menutupi seluruh layar dan bottom bar tidak tampil.
18. **Apa itu `Theme` dan mengapa warna/ukuran dipusatkan di `AppColors`, `Dimens`, `AppTheme`?** Perubahan sekali tempat berlaku di seluruh app, tampilan konsisten.
19. **Apa fungsi `Semantics` dan mengapa penting di aplikasi ini?** Memberi label untuk pembaca layar agar pengguna tunanetra tahu fungsi elemen.
20. **Mengapa memakai `const` pada widget?** Objek dibuat sekali pada waktu kompilasi dan tidak dibangun ulang, lebih efisien.
21. **Apa itu `BuildContext`?** Penanda posisi widget di pohon. Dipakai untuk mencari Theme, MediaQuery, AppScope, dan navigasi.
22. **Apa beda `final` dan `const`?** `final` ditetapkan sekali saat runtime. `const` sudah konstan sejak kompilasi.
23. **Apa arti `late`?** Variabel baru diinisialisasi saat pertama dipakai.
24. **Jelaskan alur saat pengguna menekan ikon bookmark di Home.**
    Ikon -> `onFavoriteToggle` -> `news.toggleFavorite(id)` -> list baru dengan `copyWith(isFavorite: !...)` -> `notifyListeners()` -> `ListenableBuilder` di Home, Favorit, Detail rebuild -> ikon berubah dan tab Favorit memuat berita itu.
25. **Mengapa tombol suara belum berfungsi?** Belum ada layanan TTS. Kode ditandai `shortcut` untuk diganti saat TTS dibuat.

---

## 5. Latihan live coding

Format: soal, file yang diubah, jawaban. Coba kerjakan sendiri dulu sebelum melihat jawaban. Tips: jalankan `flutter run`, tekan `r` (hot reload) setelah tiap perubahan.

### Kelompok A. Tampilan, warna, font

**A1. Ubah warna utama aplikasi dari kuning menjadi biru.**
File: `lib/core/theme/app_colors.dart`
```dart
static const Color primary = Color(0xFF2563EB);
static const Color primaryLight = Color(0xFFDBEAFE);
static const Color primaryDark = Color(0xFF1E3A8A);
```
Format warna: `0xFF` + kode hex RGB. Cek kontras teks `onPrimary` (hitam) masih terbaca.

**A2. Ubah warna teks judul berita (hanya satu tempat).**
File: `lib/features/home/widgets/news_card.dart`
```dart
Text(news.title, style: textTheme.titleMedium?.copyWith(color: Colors.red)),
```

**A3. Perbesar ukuran judul di semua layar.**
File: `lib/core/theme/app_theme.dart`, di `titleMedium`: ganti `fontSize: 16.0` menjadi `20.0`. Karena lewat tema, semua `Text(..., style: textTheme.titleMedium)` ikut berubah.

**A4. Ganti font.**
Jika font bawaan: `ThemeData(fontFamily: 'Roboto', ...)` di `app_theme.dart`. Jika font sendiri: taruh file di `assets/fonts/`, daftarkan di `pubspec.yaml`:
```yaml
flutter:
  fonts:
    - family: MyFont
      fonts:
        - asset: assets/fonts/MyFont-Regular.ttf
```
lalu `fontFamily: 'MyFont'`. Jalankan `flutter pub get`.

**A5. Beri sudut tumpul lebih besar pada kartu dan warna latar kartu.**
File: `news_card.dart`
```dart
Card(
  color: AppColors.primaryLight,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  clipBehavior: Clip.antiAlias,
  child: ...
)
```

**A6. Buat kartu cuaca berlatar warna dengan teks tebal.**
File: `weather_card.dart`, ubah `Card(` menjadi `Card(color: AppColors.primaryLight, ...`, dan `Text(weather.temperature, style: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w900))`.

**A7. Ganti ikon bookmark menjadi hati.**
File: `news_card.dart` dan `news_detail_screen.dart`: ganti `Icons.bookmark_rounded` menjadi `Icons.favorite` dan `Icons.bookmark_outline_rounded` menjadi `Icons.favorite_border`.

### Kelompok B. Ukuran

**B1. Perbesar semua tombol (tinggi tombol).**
File: `lib/core/theme/dimens.dart`: `this.buttonHeight = 50.0` menjadi `64.0`. Karena `elevatedButtonTheme` memakai `Dimens.buttonHeight`, semua `ElevatedButton` ikut.

**B2. Perbesar hanya satu tombol "Dengarkan Cuaca".**
File: `weather_card.dart`
```dart
SizedBox(
  height: 72,
  child: ElevatedButton.icon(onPressed: onListenPressed, icon: ..., label: ...),
)
```
Catatan: tema memakai `minimumSize: Size.fromHeight(...)` sehingga lebar sudah penuh.

**B3. Perbesar ikon dan teks bottom bar.**
File: `main_shell.dart`, di `BottomNavigationBar` tambahkan `iconSize: 32, selectedFontSize: 16, unselectedFontSize: 14`.

**B4. Perbesar logo di AppBar.**
File: `dimens.dart`: `avatarSize = 36.0` menjadi `56.0`. Jika AppBar jadi terpotong, tambah `toolbarHeight` di `AppBar` dan sesuaikan `preferredSize`.

**B5. Batasi lebar konten jadi lebih sempit.**
File: `dimens.dart`: `maxContentWidth = 720.0` menjadi `480.0`.

**B6. Perbesar jarak antar kartu.**
File: `home_screen.dart`, ganti `SizedBox(height: dimens.spacingMedium)` setelah `NewsCard` menjadi `dimens.spacingXXLarge`.

### Kelompok C. Posisi dan susunan

**C1. Pindahkan kartu cuaca ke bawah daftar berita.**
File: `home_screen.dart`. Dalam `Column(children: [...])`, pindahkan blok `WeatherCard(...)` + `SizedBox` ke setelah `for (...)`. Urutan children = urutan tampil.

**C2. Tukar posisi kategori dan cuaca.**
Tukar dua blok `WeatherCard` dan `CategoryChips` beserta `SizedBox` di bawahnya.

**C3. Ubah susunan kartu berita: tombol "Dengarkan" di sebelah kanan judul.**
File: `news_card.dart`. Ganti bagian judul + tombol dengan `Row`:
```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(child: Text(news.title, style: textTheme.titleMedium)),
    SizedBox(width: dimens.spacingMedium),
    IconButton(
      onPressed: onListen,
      icon: const Icon(Icons.headphones_rounded),
      tooltip: 'Dengarkan berita',
    ),
  ],
)
```

**C4. Pindahkan bookmark ke kiri dan kategori ke kanan.**
Di `Row` paling atas `NewsCard`, tukar urutan `Expanded(kategori)` dan blok bookmark/waktu.

**C5. Pusatkan teks judul section.**
`Text('Berita Utama', textAlign: TextAlign.center)` dalam `Column` dengan `crossAxisAlignment: CrossAxisAlignment.stretch` (teks akan memenuhi lebar sehingga center terlihat). Atau bungkus `Center(child: ...)`.

**C6. Tampilkan dua kartu bersebelahan.**
Gunakan `Row(children: [Expanded(child: NewsCard(...)), SizedBox(width: 12), Expanded(child: NewsCard(...))])`. Jika overflow, kartu perlu lebih ringkas.

**C7. Tumpuk badge di atas kartu (Stack).**
```dart
Stack(children: [
  NewsCard(...),
  const Positioned(top: 8, right: 8, child: AppStatusBadge()),
])
```

### Kelompok D. Navigasi

**D1. Tambah halaman "Tentang" dan buka dari Pengaturan.**
1. Buat `lib/features/about/about_screen.dart`:
```dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang')),
      body: const SafeArea(child: Center(child: Text('Gemanatra 1.0.0'))),
    );
  }
}
```
2. `lib/app/router.dart`: tambah `static const about = '/about';` di `AppRoutes` dan di `routes:` (sejajar dengan `/news/:id`):
```dart
GoRoute(path: AppRoutes.about, builder: (context, state) => const AboutScreen()),
```
3. Di `settings_screen.dart`, tambah tile dengan `onTap`:
```dart
SettingTile(
  title: 'Tentang Aplikasi',
  subtitle: 'Informasi versi',
  onTap: () => context.push(AppRoutes.about),
),
```
Tambahkan import `go_router` dan `router.dart`.

**D2. Tambah tab keempat "Riwayat".**
1. Buat `HistoryScreen`.
2. `router.dart`: tambah `StatefulShellBranch` ke-4 dengan `GoRoute(path: '/history', ...)`.
3. `main_shell.dart`: tambah `BottomNavigationBarItem` ke-4. **Urutan item harus sama dengan urutan branch.**

**D3. Ubah urutan tab (Favorit jadi pertama).**
Tukar urutan `StatefulShellBranch` di `router.dart` **dan** urutan `BottomNavigationBarItem` di `main_shell.dart`. Path awal (`initialLocation`) bisa dipertahankan.

**D4. Tambah tombol kembali di halaman baru.**
`AppBar` otomatis menampilkan panah kembali jika halaman dibuka dengan `push`. Manual: `Navigator.of(context).pop()` atau `context.pop()`.

**D5. Buka halaman detail saat judul di Favorit diketuk.**
Sudah ada lewat `onTap: () => context.push(AppRoutes.newsDetail(item.id))`. Latihan: jelaskan jalurnya dari ketukan sampai `NewsDetailScreen` muncul (kartu -> push path -> router cocokkan `/news/:id` -> baca `id` -> constructor `newsId`).

### Kelompok E. State dan logika

**E1. Tambah kategori baru "Olahraga".**
Karena kategori diambil dari data, tambah `'Olahraga'` ke `_categories` di `home_screen.dart`, dan tambahkan satu `NewsItem` dengan `category: 'Olahraga'` di `sample_news.dart`.

**E2. Tambah kotak pencarian di Home.**
File: `home_screen.dart`. Karena sudah Stateful, tambahkan:
```dart
final _search = TextEditingController();
String _query = '';

@override
void dispose() {
  _search.dispose();
  super.dispose();
}
```
Di `Column`, sebelum `CategoryChips`:
```dart
TextField(
  controller: _search,
  decoration: const InputDecoration(
    hintText: 'Cari berita',
    prefixIcon: Icon(Icons.search),
  ),
  onChanged: (text) => setState(() => _query = text),
),
```
Dan pada perhitungan `filteredNews` tambahkan filter:
```dart
.where((item) => item.title.toLowerCase().contains(_query.toLowerCase()))
```
(disambung setelah mendapatkan daftar, lalu `.toList()`).

**E3. Tampilkan jumlah berita di judul section.**
`Text('Berita Utama (${filteredNews.length})', style: textTheme.titleMedium)`.

**E4. Tampilkan pesan jika hasil filter kosong.**
```dart
if (filteredNews.isEmpty)
  const Text('Belum ada berita pada kategori ini'),
```
diletakkan sebelum `for`.

**E5. Tambah penghitung "dibaca" di NewsController.**
Tambahkan field `final Set<String> _readIds = {};`, getter `bool isRead(String id) => _readIds.contains(id);` dan method `markRead(String id) { if (_readIds.add(id)) notifyListeners(); }`. Panggil `markRead` di `initState` detail, atau saat kartu diketuk. Tunjukkan di kartu dengan teks "Sudah dibaca". Jelaskan mengapa perlu `notifyListeners()`.

**E6. Tambah toggle di Pengaturan yang benar-benar berpengaruh.**
Contoh: `highContrast` mengganti warna kartu. Ambil `settings.highContrast` lewat `AppScope` di `NewsCard` pemanggil, bungkus dengan `ListenableBuilder(listenable: settings)`. Ini melatih memahami bahwa controller global boleh dibaca layar mana saja.

**E7. Ubah teks tombol saat suara diputar di Home (tanpa suara asli).**
Pindahkan konsep dari Detail: buat `String? _playingId` di `_HomeScreenState`, set di `_playNewsVoice` dengan `setState`.

### Kelompok F. Memperbaiki masalah

**F1. Perbaiki overflow.**
Gejala: pita kuning-hitam di tepi. Penyebab: `Text` panjang dalam `Row`. Solusi: `Expanded(child: Text(..., overflow: TextOverflow.ellipsis))`.

**F2. Perbaiki "unbounded height".**
Penyebab: `ListView` dalam `Column`. Solusi: bungkus `Expanded`, atau ganti `Column` menjadi satu `ListView`.

**F3. Perbaiki UI tidak berubah setelah data berubah.**
Cek tiga hal: (1) controller memanggil `notifyListeners()`, (2) widget membaca data di dalam `ListenableBuilder`, (3) `ListenableBuilder` mendengarkan controller yang benar.

**F4. Perbaiki `Null check operator used on a null value` / `setState() called after dispose`.**
Pastikan callback async mengecek `if (!mounted) return;` sebelum `setState`.

---

## 6. Urutan belajar dan checklist

Urutan yang disarankan (dari paling penting):
1. Pohon widget, Stateless vs Stateful, `setState`.
2. `Row`, `Column`, `Expanded`, `Padding`, `SizedBox`, `Container`, `ConstrainedBox`.
3. `Text`, `Icon`, tombol, `Card`, `Scaffold`, `AppBar`.
4. Scroll: `SingleChildScrollView`, `ListView.builder`.
5. Tema: `Theme.of`, `AppColors`, `Dimens`, `TextTheme`.
6. State bersama: `ChangeNotifier`, `AppScope`, `ListenableBuilder`.
7. Navigasi: `context.push`, `GoRoute`, shell tab.
8. `TextField` + controller + `dispose`.
9. `Future`/`async` dasar.

Checklist sebelum ujian. Pastikan bisa:
- [ ] menjelaskan alur "ketuk bookmark" dari ujung ke ujung tanpa melihat kode,
- [ ] membuat layar baru Stateless dan Stateful dari nol,
- [ ] mengubah warna, ukuran, font lewat tema dan lewat satu widget saja,
- [ ] memperbaiki overflow dan unbounded height,
- [ ] menambah halaman baru dan menautkannya dari tombol,
- [ ] menambah `TextField` dengan controller dan `dispose`,
- [ ] menjelaskan mengapa sebuah widget Stateful atau Stateless,
- [ ] memberi `Semantics` pada tombol baru.

Cara latihan efektif: tutup panduan ini, buka satu file, tebak apa yang ditampilkannya, ubah satu hal, hot reload, lihat hasilnya. Ulangi dengan cara yang sama sampai tiap soal di bagian 5 bisa dikerjakan tanpa melihat jawaban.
