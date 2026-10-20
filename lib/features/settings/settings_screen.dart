import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/theme/dimens.dart';
import '../../core/widgets/gemanatra_app_bar.dart';
import 'widgets/setting_section.dart';
import 'widgets/setting_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final settings = AppScope.of(context).settings;

    return Scaffold(
      appBar: const GemanatraAppBar(
        title: 'Pengaturan',
        subtitle: 'Aksesibilitas & Preferensi',
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dimens.maxContentWidth),
            child: ListenableBuilder(
              listenable: settings,
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
                            subtitle: 'Sesuaikan tempo suara pembaca berita dan cuaca',
                            trailing: DropdownButton<String>(
                              value: settings.speechRate,
                              isExpanded: true,
                              underline: const SizedBox.shrink(),
                              onChanged: (value) {
                                if (value != null) {
                                  settings.setSpeechRate(value);
                                }
                              },
                              items: settings.availableSpeechRates.map((rate) {
                                return DropdownMenuItem(
                                  value: rate,
                                  child: Text(
                                    rate,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SettingTile(
                            title: 'Putar Suara Otomatis',
                            subtitle: 'Langsung membacakan konten saat artikel dibuka',
                            trailing: Switch(
                              value: settings.autoPlay,
                              onChanged: settings.toggleAutoPlay,
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
                            subtitle: 'Gunakan palet warna terverifikasi standar WCAG AAA',
                            trailing: Switch(
                              value: settings.highContrast,
                              onChanged: settings.toggleHighContrast,
                            ),
                          ),
                          SettingTile(
                            title: 'Ukuran Teks',
                            subtitle:
                                'Sesuaikan skala huruf untuk kemudahan membaca',
                            trailing: DropdownButton<String>(
                              value: settings.textSize,
                              isExpanded: true,
                              underline: const SizedBox.shrink(),
                              onChanged: (value) {
                                if (value != null) settings.setTextSize(value);
                              },
                              items: settings.availableTextSizes.map((size) {
                                return DropdownMenuItem(
                                  value: size,
                                  child: Text(
                                    size,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                              value: settings.selectedCity,
                              isExpanded: true,
                              underline: const SizedBox.shrink(),
                              onChanged: (value) {
                                if (value != null) {
                                  settings.setSelectedCity(value);
                                }
                              },
                              items: settings.availableCities.map((city) {
                                return DropdownMenuItem(
                                  value: city,
                                  child: Text(
                                    city,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: dimens.spacingLarge),

                      // 4. Informasi & Panduan
                      const SettingSection(
                        title: 'Panduan Aksesibilitas',
                        icon: Icons.help_outline,
                        children: [
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
        ),
      ),
    );
  }
}
