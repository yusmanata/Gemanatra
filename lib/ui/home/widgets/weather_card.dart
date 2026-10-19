import 'package:flutter/material.dart';

import '../../../domain/models/weather_summary.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/dimens.dart';

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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wb_sunny_rounded,
                        color: AppColors.primaryDark,
                        size: dimens.iconSizeMediumSmall,
                      ),
                      SizedBox(width: dimens.spacingSmall),
                      Text('CUACA HARI INI', style: textTheme.labelMedium),
                    ],
                  ),
                  SizedBox(width: dimens.spacingSmall),
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
              SizedBox(height: dimens.spacingMediumSmall),
              Row(
                children: [
                  Text(weather.temperature, style: textTheme.displayLarge),
                  SizedBox(width: dimens.spacingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.condition,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.weatherAlert,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: dimens.spacingTiny),
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
              SizedBox(height: dimens.spacingMedium),
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
