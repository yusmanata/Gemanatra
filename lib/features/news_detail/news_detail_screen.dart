import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/models/news_item.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/dimens.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key, required this.newsId});

  final String newsId;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _isPlayingVoice = false;

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final controller = AppScope.of(context).news;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final news = controller.findById(widget.newsId);
        final isFavorite = news?.isFavorite ?? false;

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
                  label: isFavorite
                      ? 'Hapus dari berita favorit'
                      : 'Simpan ke berita favorit',
                  button: true,
                  child: IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_outline_rounded,
                      color: isFavorite
                          ? AppColors.primaryDark
                          : AppColors.textPrimary,
                      size: dimens.iconSizeMediumLarge,
                    ),
                    onPressed: () => controller.toggleFavorite(news.id),
                    tooltip: isFavorite
                        ? 'Tersimpan di Favorit'
                        : 'Simpan ke Favorit',
                  ),
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
                        isPlayingVoice: _isPlayingVoice,
                        onToggleVoice: () =>
                            setState(() => _isPlayingVoice = !_isPlayingVoice),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

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
      padding: EdgeInsets.fromLTRB(
        dimens.paddingScreenHorizontal,
        dimens.paddingScreenVertical,
        dimens.paddingScreenHorizontal,
        dimens.paddingScreenVertical + dimens.spacingHuge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: dimens.spacingLarge,
        children: [
          // 1. Spanduk Pemutar Suara Asistif (TTS Audio Player)
          _AudioPlaybackBanner(
            news: news,
            isPlaying: isPlayingVoice,
            onToggle: onToggleVoice,
          ),

          // 2. Metadata Artikel (Kategori, Waktu, Penulis, Judul)
          _ArticleHeaderSection(news: news),

          const Divider(),

          // 3. Isi Lengkap Artikel
          _ArticleParagraphs(content: news.content),
        ],
      ),
    );
  }
}

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
            spacing: dimens.spacingMedium,
            children: [
              Row(
                spacing: dimens.spacingMedium,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: dimens.spacingTiny,
                      children: [
                        Text(
                          isPlaying
                              ? 'Sedang Membacakan Berita...'
                              : 'Dengarkan Versi Suara',
                          style: textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
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

class _ArticleHeaderSection extends StatelessWidget {
  const _ArticleHeaderSection({required this.news});

  final NewsItem news;

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: dimens.spacingMedium,
      children: [
        Row(
          spacing: dimens.spacingMedium,
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
            Expanded(
              child: Text(
                '${news.timeAgo} • ${news.author}',
                style: textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Semantics(
          header: true,
          child: Text(news.title, style: textTheme.titleLarge),
        ),
      ],
    );
  }
}

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
      spacing: dimens.spacingLarge,
      children: [
        for (final paragraph in paragraphs)
          Semantics(
            child: Text(
              paragraph.trim(),
              style:
                  textTheme.bodyLarge ??
                  const TextStyle(
                    fontSize: 16.0,
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
      ],
    );
  }
}

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
          spacing: dimens.spacingMedium,
          children: [
            Icon(
              Icons.article_outlined,
              size: dimens.iconSizeXLarge,
              color: AppColors.textSecondary,
            ),
            Text(
              'Berita Tidak Ditemukan',
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              'Artikel yang Anda tuju mungkin telah dihapus atau tidak tersedia.',
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
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
