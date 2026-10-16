# AGENTS.md — Aturan Arsitektur & Kode Flutter

Dokumen ini adalah aturan wajib untuk setiap agen AI (dan developer) yang menulis kode di proyek ini.
Semua aturan mengikuti **Compass App** milik tim Flutter dan panduan arsitektur resminya.

- Repo referensi: https://github.com/flutter/samples/tree/main/compass_app (folder `app/`)
- Panduan resmi: https://docs.flutter.dev/app-architecture/guide
- Case study: https://docs.flutter.dev/app-architecture/case-study
- Rekomendasi: https://docs.flutter.dev/app-architecture/recommendations
- Error layout umum: https://docs.flutter.dev/testing/common-errors

Jika ada konflik antara dokumen ini dan kebiasaan umum, **dokumen ini menang**.
Jika dokumen ini tidak mengatur sesuatu, cari pola serupa di kode yang sudah ada, lalu ikuti. Jangan membuat pola baru.

---

## 0. Cara kerja agen (WAJIB dibaca dulu)

Sebelum menulis kode:
1. Baca struktur `lib/` yang sudah ada dan cari fitur terdekat sebagai contoh. Tiru polanya.
2. Tentukan layer mana yang diubah: `data`, `domain`, atau `ui`. Satu perubahan = tanggung jawab yang jelas.
3. Jangan menambah package baru tanpa izin eksplisit dari user.

Setelah menulis kode:
1. Jalankan `dart format .`, `flutter analyze`, dan `flutter test`. Perbaiki semua temuan, jangan di-suppress.
2. Jalankan `dart run build_runner build --delete-conflicting-outputs` bila mengubah model `freezed` / `json_serializable`.
3. Cek checklist di bagian 12 sebelum menyatakan selesai.

Prinsip utama: **separation of concerns**. Widget hanya menampilkan. ViewModel mengelola state UI. Repository adalah sumber kebenaran data. Service hanya membungkus API eksternal.

---

## 1. Struktur folder

Gabungan *by feature* (UI) dan *by type* (data). Data layer dipakai lintas fitur, UI layer terikat ke satu fitur.

```
lib/
├── ui/
│   ├── core/
│   │   ├── ui/            # widget bersama (tombol brand, ErrorIndicator, dll)
│   │   ├── themes/        # colors.dart, dimens.dart, theme
│   │   └── localization/
│   └── <feature_name>/
│       ├── view_models/   # <feature>_viewmodel.dart
│       └── widgets/       # <feature>_screen.dart + widget pendukung fitur itu
├── domain/
│   ├── models/            # model domain (immutable)
│   └── use_cases/         # OPSIONAL, lihat bagian 4.5
├── data/
│   ├── repositories/<nama>/   # abstract + *_remote.dart + *_local.dart
│   ├── services/              # api/, local/, shared_preferences_service.dart
│   └── model/                 # model mentah API (*ApiModel)
├── config/                # dependencies.dart, env/environment
├── routing/               # router.dart, routes.dart
├── utils/                 # result.dart, command.dart, helper umum
├── main.dart              # entry production
├── main_development.dart  # entry dev (repository lokal/fake)
└── main_staging.dart
test/                      # struktur mirror lib/ (data, domain, ui, utils)
testing/                   # fakes & mock yang dipakai test (fakes/, models/)
```

Aturan:
- Satu fitur = satu folder di `ui/`. Satu `View` ⇄ satu `ViewModel` (relasi 1:1).
- Widget yang dipakai lebih dari satu fitur masuk ke `ui/core/ui/`.
- **Dilarang** membuat folder bernama `widgets/` di root `lib/` atau nama lain yang bentrok dengan istilah Flutter SDK. Widget bersama selalu di `ui/core/ui/`.
- Satu file = satu kelas publik utama. Nama file `snake_case`, sama dengan nama kelas.

---

## 2. Aturan komunikasi antar layer

| Komponen   | Boleh tahu tentang                          | Dilarang                                              |
|------------|---------------------------------------------|-------------------------------------------------------|
| View       | Tepat **satu** ViewModel miliknya           | Mengakses Repository, Service, atau ViewModel lain    |
| ViewModel  | Satu atau lebih **Repository** (via constructor) | Mengetahui View; memegang `BuildContext`; memanggil Service langsung |
| Repository | Banyak **Service** (via constructor)        | Mengetahui ViewModel; mengimpor apa pun dari `ui/`    |
| Service    | Tidak tahu siapa pun                        | Mengetahui Repository atau layer lain                 |

Arah data **searah (unidirectional)**: data mengalir dari data layer ke UI. Event dari UI dikirim ke data layer untuk diproses.

Dependency di ViewModel dan Repository **selalu private** (`final BookingRepository _bookingRepository;`) supaya View tidak bisa menembus ke data layer.

---

## 3. Data layer

### 3.1 Service
- Kelas **stateless**, tanpa side effect internal. Tugasnya hanya membungkus satu sumber data (HTTP client, plugin platform, shared preferences).
- Satu service per sumber data.
- Setiap method mengembalikan `Future<Result<T>>`. Tipe `T` adalah model mentah (`*ApiModel`).
- Service tidak menyimpan cache dan tidak mengandung logika bisnis.

### 3.2 Repository
- **Sumber kebenaran** untuk satu jenis data dan satu-satunya tempat data itu diubah.
- Satu repository per jenis data (`UserRepository`, `BookingRepository`, `DestinationRepository`, ...).
- **Selalu buat kelas abstrak**, lalu implementasi per lingkungan:
  `BookingRepository` (abstract) → `BookingRepositoryRemote`, `BookingRepositoryLocal`.
- Bertanggung jawab atas: transformasi `ApiModel` → model domain, caching, retry, polling, sinkronisasi offline.
- Menerima Service lewat constructor, disimpan sebagai field private.
- Mengembalikan model **domain**, bukan model API.

```dart
class BookingRepositoryRemote implements BookingRepository {
  BookingRepositoryRemote({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<void>> delete(int id) async {
    try {
      return _apiClient.deleteBooking(id);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
```

### 3.3 Result (penanganan error)
Gunakan `Result<T>` (sealed class `Ok` / `Error`) dari `utils/result.dart`. **Jangan** melempar exception ke UI.

```dart
switch (result) {
  case Ok<User>():
    _user = result.value;
  case Error<User>():
    _log.warning('Failed to load user', result.error);
}
```

- Pakai `switch` exhaustive pada `Result`, bukan `is`-chain atau `!`.
- Tangkap `Exception` di Repository/Service, bungkus ke `Result.error(e)`.

### 3.4 Model
- Model API (`data/model/*ApiModel`) dan model domain (`domain/models/*`) **dipisah**.
- Model domain **immutable** dan dibuat dengan `freezed` (+ `json_serializable` bila perlu `fromJson`).
- Tidak ada setter publik. Perubahan = `copyWith` / instance baru.

---

## 4. UI layer (MVVM)

### 4.1 ViewModel
- Nama: `<Feature>ViewModel`, extends `ChangeNotifier`.
- Menerima Repository lewat constructor (named, `required`), disimpan private.
- Mengekspos state sebagai **getter publik yang immutable** (`UnmodifiableListView`, objek `freezed`). Field mutable-nya private.
- Memanggil `notifyListeners()` setelah state berubah (pola `try { ... } finally { notifyListeners(); }`).
- **Semua logika UI ada di sini**, bukan di widget.
- Dilarang: `BuildContext`, `Navigator`, `ScaffoldMessenger`, import `package:flutter/material.dart` (kecuali `foundation`).
- Logging pakai `package:logging` (`final _log = Logger('HomeViewModel');`), bukan `print`.

### 4.2 Command (aksi dari UI)
Setiap aksi UI yang async (load, delete, submit) dibungkus `Command0` / `Command1` dari `utils/command.dart`.

```dart
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required BookingRepository bookingRepository,
    required UserRepository userRepository,
  })  : _bookingRepository = bookingRepository,
        _userRepository = userRepository {
    load = Command0(_load)..execute();
    deleteBooking = Command1(_deleteBooking);
  }

  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;

  late final Command0 load;
  late final Command1<void, int> deleteBooking;
  // ...
}
```

- Command memberi state `running`, `error`, `completed`, dan mencegah eksekusi ganda (mis. tap tombol berkali-kali).
- Action wajib mengembalikan `Future<Result<T>>`.
- Command dibuat di constructor ViewModel dan jadi properti ViewModel, sehingga View aman dirender sebelum data ada.
- Setelah hasil command dikonsumsi (mis. snackbar), panggil `clearResult()`.

### 4.3 View (widget)
- Nama: `<Feature>Screen` atau nama komponen (`LogoutButton`). File di `ui/<feature>/widgets/`.
- Input View hanya: `key` dan ViewModel-nya (`required this.viewModel`).
- Tanggung jawab View hanya tiga: (1) menampilkan data dari ViewModel, (2) mendengarkan perubahan dan rebuild, (3) memasang callback ViewModel ke event handler.
- **Logika di widget dibatasi** pada: `if` sederhana untuk show/hide, logika animasi, logika layout berbasis ukuran layar/orientasi, dan routing sederhana.
- Rebuild dengan `ListenableBuilder(listenable: viewModel, ...)`. Pecah per command bila perlu:

```dart
ListenableBuilder(
  listenable: widget.viewModel.load,
  builder: (context, child) {
    if (widget.viewModel.load.running) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.viewModel.load.error) {
      return ErrorIndicator(
        title: AppLocalization.of(context).errorWhileLoadingHome,
        label: AppLocalization.of(context).tryAgain,
        onPressed: widget.viewModel.load.execute,
      );
    }
    return child!; // konten utama, dibangun sekali lewat parameter `child`
  },
  child: /* konten utama */,
)
```

- Urutan state yang ditangani: loading → error (dengan tombol coba lagi) → konten.

### 4.4 UI state
- UI state adalah snapshot immutable. Jika state satu layar kompleks, buat kelas khusus (`HomeUiState`) dengan `freezed`.

### 4.5 Domain layer / use case
- **Opsional.** Hanya buat `domain/use_cases/` bila logika sangat kompleks atau berulang di banyak ViewModel (contoh nyata di Compass: `BookingCreateUseCase`, `BookingShareUseCase`).
- Default-nya **tidak** membuat use case. Jangan menambah lapisan tanpa kebutuhan.

---

## 5. StatelessWidget vs StatefulWidget

Default: **`StatelessWidget`**. Gunakan `StatefulWidget` hanya jika salah satu benar:

1. **Ephemeral state** milik satu widget saja yang tidak dibutuhkan bagian lain app dan boleh reset saat app ditutup (tab terpilih, halaman `PageView`, progres animasi).
2. Perlu **lifecycle**: `initState` / `dispose` / `didUpdateWidget` (pasang dan lepas listener, `AnimationController`, `TextEditingController`, `ScrollController`, `FocusNode`).

Contoh nyata di Compass: `HomeScreen` adalah `StatefulWidget` karena memasang listener `deleteBooking` di `initState` dan melepasnya di `dispose`. Komponen kecil seperti `_Booking` adalah `StatelessWidget`.

Aturan:
- **App state** (data bersama, login, keranjang, preferensi, data yang disimpan antar sesi) **bukan** di `setState`. Taruh di Repository dan ViewModel.
- `setState` hanya untuk ephemeral state, dan **tidak boleh dipanggil dari `build`** (langsung maupun lewat `showDialog` di `build`).
- Setiap controller/listener yang dibuat di `initState` **wajib** dilepas di `dispose`.
- Jangan simpan data hasil fetch di `State`. Itu tugas ViewModel.
- Jangan membuat `StatefulWidget` hanya agar bisa memakai `setState` untuk memicu rebuild dari data ViewModel. Pakai `ListenableBuilder`.

---

## 6. Layout: Row, Column, dan mengatasi overflow

Flutter layout = constraint turun, ukuran naik. Pahami penyebab, jangan menambal gejala.

### 6.1 `RenderFlex overflowed`
Penyebab umum: child di `Row`/`Column` tidak dibatasi ukurannya (mis. `Text` panjang di dalam `Row`).
Perbaikan, urut prioritas:
1. Bungkus child yang boleh memanjang dengan **`Expanded`** (atau `Flexible` dengan `flex`).
2. Untuk teks panjang: `Expanded` + `overflow: TextOverflow.ellipsis` / `maxLines`, atau biarkan wrap.
3. Bila seluruh konten bisa lebih tinggi dari layar: gunakan widget scroll (bagian 6.3), bukan memperkecil font atau memotong konten.

### 6.2 `Vertical viewport was given unbounded height`
Penyebab: `ListView`/`GridView` langsung di dalam `Column` tanpa batas tinggi.
Perbaikan: bungkus dengan **`Expanded`**, atau beri tinggi lewat `SizedBox`, atau `Flexible`.
**Dilarang** memakai `shrinkWrap: true` + `NeverScrollableScrollPhysics` sebagai jalan pintas untuk daftar panjang.

### 6.3 Scroll
- Layar dengan header + daftar: gunakan **`CustomScrollView` + slivers** (`SliverToBoxAdapter`, `SliverList.builder`), seperti `HomeScreen` Compass. Jangan `Column` + `ListView` bersarang.
- Daftar dinamis selalu pakai constructor **`.builder`**, dan beri `key: ValueKey(item.id)` pada item yang bisa dihapus/diurutkan.
- Konten statis pendek tapi bisa melebihi layar kecil: `SingleChildScrollView`.

### 6.4 `TextField` di dalam `Row`
Wajib dibatasi lebarnya: `Row(children: [Expanded(child: TextField())])` atau `SizedBox`.

### 6.5 Aturan layout umum
- `Expanded`/`Flexible` hanya sebagai child langsung `Row`/`Column`/`Flex`. `Positioned` hanya di `Stack`.
- Bungkus body layar dengan `SafeArea`.
- **Dilarang** hardcode lebar/tinggi piksel untuk mengatasi overflow ("fix" dengan angka ajaib).
- Gunakan `const` pada semua widget yang bisa const.
- Hindari bersarang `Container` > `Padding` > `Align` yang bisa disederhanakan. Pakai `Padding`, `SizedBox`, `DecoratedBox` sesuai kebutuhan.
- Setiap `build` yang melebihi sekitar 80–100 baris dipecah menjadi widget kecil. **Pecah dengan kelas `StatelessWidget` (privat bila hanya dipakai di file itu, mis. `_Booking`), bukan method `_buildXxx()`** yang mengembalikan widget.

---

## 7. Responsif, tema, dan lokalisasi

- Ukuran padding/spasi/ukuran komponen berasal dari kelas `Dimens` (`ui/core/themes/dimens.dart`). Pola yang dipakai Compass:
  `Dimens.of(context)` memilih varian `mobile` atau `desktop` berdasarkan `MediaQuery.sizeOf(context).width`.
  Contoh: `Dimens.of(context).paddingScreenHorizontal`.
- Gunakan `MediaQuery.sizeOf(context)` (bukan `MediaQuery.of(context).size`) agar rebuild hanya saat ukuran berubah.
- Warna dari `AppColors` / `Theme.of(context).colorScheme`. Gaya teks dari `Theme.of(context).textTheme`.
  **Dilarang** hardcode `Color(0x...)`, `TextStyle(fontSize: ...)`, atau angka padding di widget fitur.
- Semua teks yang tampil ke user lewat `AppLocalization.of(context)`. **Dilarang** string literal user-facing di widget.
- Widget gaya brand yang dipakai ulang (tombol, indikator error) ada di `ui/core/ui/`.

---

## 8. Dependency injection & routing

- DI memakai **`package:provider`**. Semua dirakit di `lib/config/dependencies.dart`:
  - `providersRemote` untuk implementasi remote, `providersLocal` untuk data lokal/dev, ditambah `_sharedProviders`.
  - Service diekspos hanya untuk disuntik ke Repository via `context.read()`.
  - Repository diekspos sebagai **tipe abstrak**: `... as BookingRepository`.
  - Repository yang perlu memicu rebuild (mis. status login) memakai `ChangeNotifierProvider`.
- Entry point (`main.dart`, `main_development.dart`, `main_staging.dart`) memilih daftar provider yang sesuai.
- Tidak ada singleton/global yang bisa diakses langsung. Tidak ada `GetIt`/service locator, kecuali sudah dipakai di proyek.
- Navigasi memakai **`go_router`**. Path dikumpulkan di `routing/routes.dart` (mis. `Routes.bookingWithId(id)`), tidak ditulis sebagai string literal di widget.
- ViewModel layar penuh dibuat di konfigurasi route, repository diambil dengan `context.read()`:

```dart
GoRoute(
  path: Routes.home,
  builder: (context, state) {
    final viewModel = HomeViewModel(
      bookingRepository: context.read(),
      userRepository: context.read(),
    );
    return HomeScreen(viewModel: viewModel);
  },
),
```

---

## 9. Testing

- Unit test untuk **setiap** Service, Repository, dan ViewModel. Widget test untuk View. Routing dan DI juga diuji.
- Struktur `test/` mirror `lib/`. Mock dan fake bersama ada di `testing/` (`testing/fakes/`, `testing/models/`).
- Utamakan **fake** dibanding mock. Karena Repository abstrak, buat `Fake<Nama>Repository` di `testing/fakes/`.
- Tulis kode agar mudah di-fake: input/output jelas, dependency lewat constructor.
- `mocktail` untuk mock, `mocktail_image_network` untuk widget dengan gambar jaringan.

---

## 10. Dependency & tooling yang dipakai referensi

Dari `pubspec.yaml` Compass: `provider`, `go_router`, `freezed_annotation` + `freezed`, `json_annotation` + `json_serializable`, `logging`, `intl` + `flutter_localizations`, `shared_preferences`, `google_fonts`, `cached_network_image`, `flutter_svg`. Dev: `mocktail`, `mocktail_image_network`, `build_runner`, `integration_test`.

- Aktifkan lint resmi: `flutter_lints` (rekomendasi tim Flutter). `flutter analyze` harus bersih.
- State management default proyek ini: **`ChangeNotifier` + `ListenableBuilder`** (bukan Bloc/Riverpod/GetX). Jangan mencampur pendekatan state management.

---

## 11. Penamaan

Nama kelas mengikuti komponen arsitekturnya:

| Komponen    | Contoh                                    |
|-------------|-------------------------------------------|
| View        | `HomeScreen`, `LogoutButton`              |
| ViewModel   | `HomeViewModel`                           |
| Repository  | `UserRepository`, `UserRepositoryRemote`, `UserRepositoryLocal` |
| Service     | `ApiClient`, `SharedPreferencesService`   |
| Model API   | `BookingApiModel`                         |
| Model domain| `Booking`, `BookingSummary`               |
| Use case    | `BookingCreateUseCase`                    |

Hindari nama generik yang bentrok dengan SDK (`Widget`, `State`, `Provider`, folder `widgets/` di root).

---

## 12. Checklist anti "AI slop" (cek sebelum selesai)

Tolak dan perbaiki bila ada salah satu:

**Arsitektur**
- [ ] Ada logika bisnis/fetch data di dalam widget atau di `State`.
- [ ] Widget memanggil Repository/Service langsung.
- [ ] ViewModel memegang `BuildContext` atau memanggil Navigator/SnackBar.
- [ ] Repository bukan satu-satunya tempat data berubah, atau tidak punya kelas abstrak.
- [ ] Mengembalikan model API ke UI, atau model domain yang mutable.
- [ ] Exception dilempar ke UI alih-alih `Result.error`.
- [ ] Membuat use case/abstraksi tambahan tanpa kebutuhan nyata.
- [ ] Menambah package atau pola state management baru.

**Widget & layout**
- [ ] `StatefulWidget` tanpa alasan (bagian 5), atau `setState` untuk app state.
- [ ] Controller/listener tidak dilepas di `dispose`.
- [ ] Method `_buildXxx()` alih-alih kelas widget; `build()` sangat panjang.
- [ ] Overflow "diperbaiki" dengan angka piksel ajaib, `shrinkWrap` berlebihan, atau memotong konten.
- [ ] `ListView` di `Column` tanpa `Expanded`; `ListView` non-`.builder` untuk daftar dinamis.
- [ ] Warna, ukuran font, padding, atau string user-facing di-hardcode.
- [ ] `const` yang seharusnya bisa dipakai tidak dipakai.
- [ ] Item list yang bisa berubah tanpa `Key`.

**Kualitas**
- [ ] Komentar yang hanya mengulang kode ("// ini adalah tombol"). Komentar hanya untuk **alasan**, bukan **apa**.
- [ ] `print`, `debugPrint` tertinggal, kode mati, kode di-comment, TODO tanpa konteks.
- [ ] Penanganan error "diam" (`catch (_) {}`) atau `!` dipakai untuk membungkam nullability.
- [ ] Tidak ada test untuk Service/Repository/ViewModel yang ditambah.
- [ ] `flutter analyze` / `dart format` / `flutter test` belum dijalankan.

---

## 13. Penyimpangan

Aturan ini adalah rekomendasi tim Flutter yang diadaptasi, bukan hukum fisika. Jika sebuah aturan tidak cocok untuk kebutuhan tertentu (mis. perlu domain layer penuh, atau streams alih-alih `ChangeNotifier`), agen **harus bertanya ke user** dan menjelaskan alasannya, bukan menyimpang diam-diam. Jika disetujui, catat keputusan itu di bagian ini.

### Keputusan yang disetujui
_(kosong)_
