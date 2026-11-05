import 'package:flutter/material.dart';

import '../../../core/models/weather_summary.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/dimens.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
    required this.weather,
    required this.onListenPressed,
  });

  // null berarti masih memuat: kartu tampil dengan isian sementara agar tata letak tidak melompat.
  final WeatherSummary? weather;
  final VoidCallback onListenPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimens = Dimens.of(context);
    final summary = weather;

    return Semantics(
      container: true,
      liveRegion: true,
      label: summary == null
          ? 'Sedang memuat informasi cuaca'
          : 'Informasi cuaca hari ini di ${summary.location}: suhu ${summary.temperature}, ${summary.condition}. ${summary.details}',
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(dimens.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: dimens.spacingMedium,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: dimens.spacingSmall,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: dimens.spacingSmall,
                    children: [
                      Icon(
                        Icons.wb_sunny_rounded,
                        color: AppColors.primaryDark,
                        size: dimens.iconSizeMediumSmall,
                      ),
                      Text('CUACA HARI INI', style: textTheme.labelMedium),
                    ],
                  ),
                  Flexible(
                    child: Text(
                      summary?.location ?? 'Mencari lokasi...',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                spacing: dimens.spacingMedium,
                children: [
                  Text(
                    summary?.temperature ?? '--°C',
                    style: textTheme.displayLarge,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: dimens.spacingTiny,
                      children: [
                        Text(
                          summary?.condition ?? 'Memuat cuaca...',
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.weatherAlert,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          summary?.details ?? 'Mohon tunggu sebentar',
                          style: textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: summary == null ? null : onListenPressed,
                icon: Icon(
                  Icons.cloud_outlined,
                  size: dimens.iconSizeMediumLarge,
                ),
                label: const Text('Dengarkan Cuaca'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
