import 'package:flutter/material.dart';

import '../../core/themes/dimens.dart';
import '../../core/ui/gemanatra_app_bar.dart';
import '../view_models/settings_viewmodel.dart';
import 'setting_section.dart';
import 'setting_tile.dart';

/// Layar Pengaturan Aksesibilitas & Aplikasi Gemanatra.
/// Dirancang ramah tunanetra dan low-vision dengan tombol dan teks jelas.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);

    return Scaffold(
      appBar: const GemanatraAppBar(
        title: 'Pengaturan',
        subtitle: 'Aksesibilitas & Preferensi',
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: dimens.paddingScreenHorizontal,
                vertical: dimens.paddingScreenVertical,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Seksi Aksesibilitas Suara
                  SettingSection(
                    title: 'Aksesibilitas Suara (TTS)',
                    icon: Icons.record_voice_over,
                    children: [
                      SettingTile(
                        title: 'Kecepatan Pembacaan',
                        subtitle:
                            'Sesuaikan tempo suara pembaca berita dan cuaca',
                        trailing: DropdownButton<String>(
                          value: viewModel.speechRate,
                          underline: const SizedBox.shrink(),
                          onChanged: (value) {
                            if (value != null) viewModel.setSpeechRate(value);
                          },
                          items: viewModel.availableSpeechRates.map((rate) {
                            return DropdownMenuItem(
                              value: rate,
                              child: Text(rate),
                            );
                          }).toList(),
                        ),
                      ),
                      SettingTile(
                        title: 'Putar Suara Otomatis',
                        subtitle:
                            'Langsung membacakan konten saat artikel dibuka',
                        trailing: Switch(
                          value: viewModel.autoPlay,
                          onChanged: viewModel.toggleAutoPlay,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dimens.spacingLarge),

                  // 2. Seksi Tampilan & Kontras
                  SettingSection(
                    title: 'Tampilan & Kontras',
                    icon: Icons.visibility,
                    children: [
                      SettingTile(
                        title: 'Mode Kontras Tinggi',
                        subtitle: 'Gunakan palet warna kontras tajam standar WCAG AAA',
                        trailing: Switch(
                          value: viewModel.highContrast,
                          onChanged: viewModel.toggleHighContrast,
                        ),
                      ),
                      SettingTile(
                        title: 'Ukuran Teks',
                        subtitle:
                            'Sesuaikan skala huruf untuk kemudahan membaca',
                        trailing: DropdownButton<String>(
                          value: viewModel.textSize,
                          underline: const SizedBox.shrink(),
                          onChanged: (value) {
                            if (value != null) viewModel.setTextSize(value);
                          },
                          items: viewModel.availableTextSizes.map((size) {
                            return DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dimens.spacingLarge),

                  // 3. Seksi Wilayah Cuaca
                  SettingSection(
                    title: 'Preferensi Wilayah Cuaca',
                    icon: Icons.location_on,
                    children: [
                      SettingTile(
                        title: 'Kota Pemantauan',
                        subtitle: 'Pilih lokasi utama laporan cuaca harian',
                        trailing: DropdownButton<String>(
                          value: viewModel.selectedCity,
                          underline: const SizedBox.shrink(),
                          onChanged: (value) {
                            if (value != null) viewModel.setSelectedCity(value);
                          },
                          items: viewModel.availableCities.map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dimens.spacingLarge),

                  // 4. Informasi & Panduan
                  SettingSection(
                    title: 'Panduan Aksesibilitas',
                    icon: Icons.help_outline,
                    children: const [
                      SettingTile(
                        title: 'Panduan Gestur Tunanetra',
                        subtitle: 'Ketuk satu kali untuk fokus suara, ketuk dua kali untuk memilih tombol aksi.',
                      ),
                      SettingTile(
                        title: 'Versi Aplikasi',
                        subtitle: 'Gemanatra 1.0.0 (Mode Pembaca Suara)',
                      ),
                    ],
                  ),
                  SizedBox(height: dimens.spacingLarge),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
