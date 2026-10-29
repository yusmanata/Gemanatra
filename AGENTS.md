# AGENTS.md — Aturan Kode Gemanatra

Aturan wajib untuk agen AI dan developer. Arsitektur mengikuti proyek referensi **Senada** (https://github.com/spirinity/senada): sederhana, berbasis `ChangeNotifier` controller, tanpa lapisan tambahan.
Jika dokumen ini tidak mengatur sesuatu, tiru pola kode yang sudah ada. Jangan membuat pola baru.

## 0. Cara kerja
- Baca fitur terdekat di `lib/` sebelum menulis, lalu tiru polanya.
- Jangan menambah package tanpa izin eksplisit user. Package yang dipakai: `get` (hanya untuk navigasi).
- Setelah menulis kode: jalankan `dart format .` dan `flutter analyze` (harus bersih).
- Jangan commit sebelum user meminta.

## 1. Struktur folder
```
lib/
├── main.dart              # GemanatraApp (Stateful): buat controller global, AppScope, GetMaterialApp
├── app/
│   └── router.dart        # AppRoutes (path) + AppPages (GetPage)
├── core/                  # dipakai lintas fitur
│   ├── app_scope.dart     # InheritedWidget penyedia controller global
│   ├── data/              # data contoh (const) sampai API tersedia
│   ├── models/            # model immutable (copyWith, tanpa setter)
│   ├── theme/             # app_colors, app_theme, dimens
│   └── widgets/           # widget bersama
└── features/<fitur>/
    ├── <fitur>_screen.dart
    ├── <fitur>_controller.dart   # hanya bila fitur punya state bersama
    └── widgets/                  # widget khusus fitur itu
```
- Satu file = satu kelas publik utama; nama file `snake_case` sama dengan nama kelas.
- Widget yang dipakai lebih dari satu fitur masuk ke `core/widgets/`.

## 2. Controller
- `XController extends ChangeNotifier`. Field mutable **private**, getter publik **immutable** (`List.unmodifiable`), aksi = method yang memanggil `notifyListeners()`.
- **Global** (dipakai banyak layar, mis. `NewsController`, `SettingsController`): dibuat di `_GemanatraAppState` (`main.dart`), dipasang di `AppScope`, di-dispose di sana, diakses lewat `AppScope.of(context).news`.
- **Lokal** (satu layar, mis. `TextEditingController`, `ScrollController`): dibuat di `State` layar itu dan wajib di-dispose di `dispose()`.
- Controller tidak mengimpor `package:flutter/material.dart`, tidak memegang `BuildContext`.
- Jangan melempar exception ke UI. Saat API ada, tangkap di controller dan ekspos state error.

## 3. Widget
- Default **`StatelessWidget`**. Gunakan `StatefulWidget` hanya bila: (a) membuat objek ber-lifecycle (controller, listener, animasi), atau (b) menyimpan state ephemeral satu layar (kategori terpilih, status tampilan).
- App state (berita, favorit, pengaturan) **bukan** di `setState`; taruh di controller global.
- Rebuild dengan `ListenableBuilder(listenable: controller, ...)`, satu per layar atau per widget kecil yang butuh. Gabungkan beberapa dengan `Listenable.merge`.
- Pecah `build` panjang menjadi kelas widget (privat `_Xxx` bila hanya dipakai di file itu). **Dilarang** method `_buildXxx()`.
- Item list yang bisa berubah memakai `ValueKey(item.id)`.

## 4. Navigasi
- GetX hanya untuk navigasi (`GetMaterialApp`, `GetPage`). State tetap `ChangeNotifier` + `AppScope`; jangan memakai `.obs`/`Obx`/`GetxController`. Semua path ada di `AppRoutes` (`app/router.dart`); jangan menulis string path di widget.
- Tab utama: `MainShell` (Stateful) dengan `IndexedStack` dan `_index`. Urutan `children` harus sama dengan urutan `items` bottom bar. Detail dan halaman penuh: `GetPage` terpisah.
- Pindah halaman: `Get.toNamed(AppRoutes.newsDetail(id))`. Parameter lewat path dan dibaca dengan `Get.parameters['id']`. Ganti halaman: `Get.offNamed`. Kembali: `Get.back()`.

## 5. Tema & aksesibilitas (aplikasi untuk tunanetra dan low vision)
- Warna dari `AppColors`, ukuran/spasi dari `Dimens.of(context)`, teks dari `Theme.of(context).textTheme`. Jangan hardcode `Color(...)`, `fontSize`, atau angka padding di widget fitur.
- Setiap elemen interaktif punya `Semantics`/`tooltip` berbahasa Indonesia yang jelas. Header memakai `Semantics(header: true)`.
- Target sentuh minimal `Dimens.minTouchTarget`. Pertahankan kontras warna di `AppColors`.
- Gunakan `const` bila bisa. Bungkus body layar dengan `SafeArea`.

## 6. Layout
- Teks panjang di `Row`: `Expanded` + `overflow`/`maxLines`. Dilarang memperbaiki overflow dengan angka piksel ajaib.
- `ListView` di dalam `Column` harus di `Expanded`. Daftar dinamis panjang memakai `.builder`; `shrinkWrap` + `NeverScrollableScrollPhysics` dilarang.
- `Expanded`/`Flexible` hanya child langsung `Row`/`Column`. `Positioned` hanya di `Stack`.

## 7. Kualitas
- Komentar hanya untuk **alasan**, satu baris. Pintasan sadar ditandai `// shortcut: <batasan>, <kapan diganti>`.
- Tidak ada `print`/`debugPrint`, kode mati, atau kode yang di-comment.
- Tidak ada `catch (_) {}` kosong dan tidak ada `!` untuk membungkam nullability tanpa alasan.
- Test tidak dibuat kecuali user memintanya.

## 8. Penyimpangan
Jika sebuah aturan tidak cocok, agen **harus bertanya ke user** dan menjelaskan alasannya, bukan menyimpang diam-diam. Keputusan yang disetujui dicatat di sini.

### Keputusan yang disetujui
- Arsitektur MVVM/Repository/Result/provider ditinggalkan; diganti pola Senada (controller + `AppScope`). Tanpa test. (Disetujui user, 2026-10-20)
- Wiring aplikasi ada di `main.dart` (tanpa `app.dart`); `app/` hanya berisi `router.dart`. (Disetujui user, 2026-10-20)
- Navigasi memakai GetX (`get`), bukan `go_router`, agar sama dengan materi praktikum. State management tidak berubah. (Disetujui user, 2026-10-29)
