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

  final WeatherSummary weather;
  final VoidCallback onListenPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimens = Dimens.of(context);

    return Semantics(
      container: true,
      label:
          'Informasi cuaca hari ini di ${weather.location}: suhu ${weather.temperature}, ${weather.condition}. ${weather.details}',
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
                      weather.location,
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
                  Text(weather.temperature, style: textTheme.displayLarge),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: dimens.spacingTiny,
                      children: [
                        Text(
                          weather.condition,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.weatherAlert,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          weather.details,
                          style: textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onListenPressed,
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
