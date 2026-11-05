import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_summary.dart';

class WeatherService {
  const WeatherService();

  // Melempar Exception bila gagal; controller yang menangkapnya.
  Future<WeatherSummary> fetchWeather({
    required String location,
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current':
          'temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code',
      'timezone': 'auto',
    });
    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw http.ClientException('Status ${response.statusCode}');
    }

    final current =
        jsonDecode(response.body)['current'] as Map<String, dynamic>;
    return WeatherSummary.fromOpenMeteo(location, current);
  }

  // Nama kota hanya pelengkap; gagal berarti null, bukan error.
  Future<String?> fetchCityName({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final uri = Uri.https(
        'api.bigdatacloud.net',
        '/data/reverse-geocode-client',
        {
          'latitude': '$latitude',
          'longitude': '$longitude',
          'localityLanguage': 'id',
        },
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final name = (json['city'] as String?)?.trim().isNotEmpty ?? false
          ? json['city'] as String
          : json['locality'] as String?;
      return (name?.trim().isEmpty ?? true) ? null : name;
    } on Exception {
      return null;
    }
  }
}
