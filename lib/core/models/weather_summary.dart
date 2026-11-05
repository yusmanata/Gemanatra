/// Model domain immutable untuk ringkasan cuaca harian.
class WeatherSummary {
  const WeatherSummary({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.details,
  });

  factory WeatherSummary.fromOpenMeteo(
    String location,
    Map<String, dynamic> current,
  ) {
    final temperature = (current['temperature_2m'] as num).round();
    final humidity = (current['relative_humidity_2m'] as num).round();
    final wind = (current['wind_speed_10m'] as num).round();

    return WeatherSummary(
      location: location,
      temperature: '$temperature°C',
      condition: _condition(current['weather_code'] as int),
      details: 'Kelembapan: $humidity% • Angin: $wind km/jam',
    );
  }

  // Kode cuaca WMO dari Open-Meteo.
  static String _condition(int code) {
    if (code == 0) return 'Cerah';
    if (code <= 2) return 'Cerah Berawan';
    if (code == 3) return 'Berawan';
    if (code <= 48) return 'Berkabut';
    if (code <= 57) return 'Gerimis';
    if (code <= 67) return 'Hujan';
    if (code <= 77) return 'Salju';
    if (code <= 82) return 'Hujan Lebat';
    return 'Badai Petir';
  }

  final String location;
  final String temperature;
  final String condition;
  final String details;

  WeatherSummary copyWith({
    String? location,
    String? temperature,
    String? condition,
    String? details,
  }) {
    return WeatherSummary(
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      condition: condition ?? this.condition,
      details: details ?? this.details,
    );
  }
}
