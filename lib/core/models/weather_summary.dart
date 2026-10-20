/// Model domain immutable untuk ringkasan cuaca harian.
class WeatherSummary {
  const WeatherSummary({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.details,
  });

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
