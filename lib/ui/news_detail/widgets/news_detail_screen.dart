import 'package:flutter/material.dart';

import '../../../domain/models/news_item.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/dimens.dart';
import '../../core/ui/app_status_badge.dart';
import '../view_models/news_detail_viewmodel.dart';

/// Halaman Detail Berita yang dirancang ramah aksesibilitas (WCAG AAA)
/// dan kompatibel dengan pembaca layar (TalkBack / VoiceOver).
class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({super.key, required this.viewModel});

  final NewsDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final news = viewModel.news;

        return Scaffold(
          appBar: AppBar(
            leading: Semantics(
              label: 'Kembali ke daftar berita sebelumnya',
              button: true,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: dimens.iconSizeMediumLarge,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: 'Kembali',
              ),
            ),
            title: Text(
              'Detail Berita',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            actions: [
              if (news != null) ...[
                Semantics(
                  label: viewModel.isFavorite
                      ? 'Hapus dari berita favorit'
                      : 'Simpan ke berita favorit',
                  button: true,
                  child: IconButton(
                    icon: Icon(
                      viewModel.isFavorite
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_outline_rounded,
                      color: viewModel.isFavorite
                          ? AppColors.primaryDark
                          : AppColors.textPrimary,
                      size: dimens.iconSizeMediumLarge,
                    ),
                    onPressed: viewModel.toggleFavorite,
                    tooltip: viewModel.isFavorite
                        ? 'Tersimpan di Favorit'
                        : 'Simpan ke Favorit',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: AppStatusBadge(),
                ),
              ],
            ],
          ),
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: dimens.maxContentWidth),
                child: news == null
                    ? const _NewsNotFoundView()
                    : _NewsDetailContent(
                        news: news,
                        isPlayingVoice: viewModel.isPlayingVoice,
                        onToggleVoice: viewModel.toggleVoicePlayback,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Konten artikel berita lengkap beserta pemutar suara asistif.
class _NewsDetailContent extends StatelessWidget {
  const _NewsDetailContent({
    required this.news,
    required this.isPlayingVoice,
    required this.onToggleVoice,
  });

  final NewsItem news;
  final bool isPlayingVoice;
  final VoidCallback onToggleVoice;

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: dimens.paddingScreenHorizontal,
        vertical: dimens.paddingScreenVertical,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Spanduk Pemutar Suara Asistif (TTS Audio Player)
          _AudioPlaybackBanner(
            news: news,
            isPlaying: isPlayingVoice,
            onToggle: onToggleVoice,
          ),
          SizedBox(height: dimens.spacingLarge),

          // 2. Metadata Artikel (Kategori, Waktu, Penulis, Judul)
          _ArticleHeaderSection(news: news),
          SizedBox(height: dimens.spacingLarge),

          const Divider(),
          SizedBox(height: dimens.spacingLarge),

          // 3. Isi Lengkap Artikel
          _ArticleParagraphs(content: news.content),
          SizedBox(height: dimens.spacingHuge),
        ],
      ),
    );
  }
}

/// Spanduk interaktif untuk memutar narasi suara berita.
class _AudioPlaybackBanner extends StatelessWidget {
  const _AudioPlaybackBanner({
    required this.news,
    required this.isPlaying,
    required this.onToggle,
  });

  final NewsItem news;
  final bool isPlaying;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      container: true,
      label: isPlaying
          ? 'Sedang memutar pembacaan suara berita. Durasi ${news.durationText}. Ketuk untuk menghentikan.'
          : 'Fitur pembacaan suara berita. Estimasi durasi ${news.durationText}. Ketuk untuk mendengarkan.',
      child: Card(
        color: isPlaying ? AppColors.primaryLight : AppColors.surface,
        child: Padding(
          padding: EdgeInsets.all(dimens.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: dimens.minTouchTarget,
                    height: dimens.minTouchTarget,
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? AppColors.primary
                          : AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying
                          ? Icons.volume_up_rounded
                          : Icons.headphones_rounded,
                      color: isPlaying
                          ? AppColors.onPrimary
                          : AppColors.primaryDark,
                      size: dimens.iconSizeMediumLarge,
                    ),
                  ),
                  SizedBox(width: dimens.spacingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPlaying
                              ? 'Sedang Membacakan Berita...'
                              : 'Dengarkan Versi Suara',
                          style: textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: dimens.spacingTiny),
                        Text(
                          'Durasi ${news.durationText} • Narasi Bahasa Indonesia',
                          style: textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: dimens.spacingMedium),
              ElevatedButton.icon(
                onPressed: onToggle,
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: dimens.iconSizeMediumLarge,
                ),
                label: Text(
                  isPlaying
                      ? 'Hentikan Pembacaan Suara'
                      : 'Dengarkan Sekarang (${news.durationText})',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bagian header artikel yang memuat kategori, tanggal terbit, penulis, dan judul.
class _ArticleHeaderSection extends StatelessWidget {
  const _ArticleHeaderSection({required this.news});

  final NewsItem news;

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: dimens.chipPaddingHorizontal,
                vertical: dimens.chipPaddingVertical,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(dimens.borderRadiusSmall),
              ),
              child: Text(
                news.category.toUpperCase(),
                style: textTheme.labelMedium,
              ),
            ),
            SizedBox(width: dimens.spacingMedium),
            Expanded(
              child: Text(
                '${news.timeAgo} • ${news.author}',
                style: textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: dimens.spacingMedium),
        Semantics(
          header: true,
          child: Text(news.title, style: textTheme.titleLarge),
        ),
      ],
    );
  }
}

/// Paragraf teks isi artikel dengan tipografi kontras tinggi.
class _ArticleParagraphs extends StatelessWidget {
  const _ArticleParagraphs({required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final textTheme = Theme.of(context).textTheme;
    final paragraphs = content
        .split('\n\n')
        .where((paragraph) => paragraph.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < paragraphs.length; i++) ...[
          Semantics(
            child: Text(
              paragraphs[i].trim(),
              style:
                  textTheme.bodyLarge ??
                  const TextStyle(
                    fontSize: 16.0,
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
          if (i < paragraphs.length - 1) SizedBox(height: dimens.spacingLarge),
        ],
      ],
    );
  }
}

/// Tampilan fallback ketika ID berita tidak ditemukan.
class _NewsNotFoundView extends StatelessWidget {
  const _NewsNotFoundView();

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(dimens.emptyStatePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.article_outlined,
              size: dimens.iconSizeXLarge,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: dimens.spacingMedium),
            Text(
              'Berita Tidak Ditemukan',
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: dimens.spacingSmall),
            Text(
              'Artikel yang Anda tuju mungkin telah dihapus atau tidak tersedia.',
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: dimens.spacingLarge),
            OutlinedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
