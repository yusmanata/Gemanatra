import 'package:flutter/material.dart';
import 'app/theme/app_colors.dart';
import 'app/theme/app_theme.dart';

void main() => runApp(const GemanatraApp());

/// Root widget aplikasi Gemanatra
class GemanatraApp extends StatelessWidget {
  const GemanatraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemanatra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Seluruh design token & typography terpusat di sini
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;
  int _selectedCategoryIndex = 0;

  final List<String> _categories = const [
    'Semua',
    'Nasional',
    'Teknologi',
    'Kesehatan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCleanAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWeatherCard(context),
              const SizedBox(height: 20.0),
              _buildCategoryChips(context),
              const SizedBox(height: 16.0),
              _buildNewsSection(context),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // 1. HEADER
  PreferredSizeWidget _buildCleanAppBar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/logo.jpg',
              width: 36.0,
              height: 36.0,
              fit: BoxFit.cover,
              semanticLabel: 'Logo Gemanatra',
              errorBuilder: (_, __, ___) => const Icon(
                Icons.volume_up_rounded,
                color: AppColors.primaryDark,
                size: 32.0,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gemanatra', style: textTheme.titleLarge, overflow: TextOverflow.ellipsis),
                Text('Suara Berita & Cuaca', style: textTheme.labelSmall, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: AppColors.statusGreenBg,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: AppColors.statusGreen.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.record_voice_over, color: AppColors.statusGreen, size: 14.0),
              const SizedBox(width: 5.0),
              Text(
                'TTS AKTIF',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.statusGreen,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(),
      ),
    );
  }

  // 2. KARTU CUACA TERKINI
  Widget _buildWeatherCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wb_sunny_rounded, color: AppColors.primaryDark, size: 18.0),
                    const SizedBox(width: 6.0),
                    Text('CUACA HARI INI', style: textTheme.labelMedium),
                  ],
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    'DKI Jakarta',
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Text('29°C', style: textTheme.displayLarge),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cerah Berawan',
                        style: textTheme.titleMedium?.copyWith(color: AppColors.weatherAlert),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Kelembapan: 72% • Angin: 14 km/jam',
                        style: textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.cloud_outlined, size: 24.0),
              label: const Text('Dengarkan Cuaca'),
            ),
          ],
        ),
      ),
    );
  }

  // 3. KATEGORI BERITA
  Widget _buildCategoryChips(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kategori Berita', style: textTheme.titleMedium),
        const SizedBox(height: 10.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_categories.length, (index) {
              final isSelected = _selectedCategoryIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedCategoryIndex = index),
                  label: Text(_categories[index]),
                  avatar: isSelected
                      ? const Icon(Icons.check, size: 16.0, color: Colors.black)
                      : null,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // 4. DAFTAR BERITA
  Widget _buildNewsSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Berita Utama', style: textTheme.titleMedium),
        const SizedBox(height: 10.0),
        _buildNewsCard(
          context,
          category: 'Teknologi',
          time: '15 menit lalu',
          title: 'Inovasi Navigasi Suara untuk Disabilitas Netra Resmi Diluncurkan',
          duration: '2 Menit',
        ),
        const SizedBox(height: 12.0),
        _buildNewsCard(
          context,
          category: 'Nasional',
          time: '1 jam lalu',
          title: 'Pemerintah Memperluas Fasilitas Guiding Block di Seluruh Stasiun Kereta',
          duration: '3 Menit',
        ),
      ],
    );
  }

  Widget _buildNewsCard(
    BuildContext context, {
    required String category,
    required String time,
    required String title,
    required String duration,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category.toUpperCase(),
                    style: textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(time, style: textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(height: 1.35),
            ),
            const SizedBox(height: 14.0),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.headphones_rounded, size: 22.0),
              label: Text('Dengarkan Berita ($duration)'),
            ),
          ],
        ),
      ),
    );
  }

  // 5. BOTTOM NAVIGATION BAR
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 1.0)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Utama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline_rounded),
            activeIcon: Icon(Icons.bookmark_rounded),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings_rounded),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
