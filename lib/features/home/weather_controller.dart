import 'package:flutter/foundation.dart';

import '../../core/models/weather_summary.dart';
import '../../core/services/location_service.dart';
import '../../core/services/weather_service.dart';

class WeatherController extends ChangeNotifier {
  // Lokasi default bila izin lokasi ditolak atau GPS mati.
  static const _defaultLocation = 'DKI Jakarta (lokasi default)';
  static const _defaultLatitude = -6.2;
  static const _defaultLongitude = 106.82;

  final _service = const WeatherService();
  final _locationService = const LocationService();

  WeatherSummary? _weather;
  bool _isLoading = false;
  String? _error;

  WeatherSummary? get weather => _weather;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final position = await _locationService.currentPosition();
      final city = position == null
          ? null
          : await _service.fetchCityName(
              latitude: position.latitude,
              longitude: position.longitude,
            );
      _weather = await _service.fetchWeather(
        location: position == null ? _defaultLocation : city ?? 'Lokasi Anda',
        latitude: position?.latitude ?? _defaultLatitude,
        longitude: position?.longitude ?? _defaultLongitude,
      );
    } on Exception {
      _error = 'Gagal memuat cuaca. Periksa koneksi internet lalu coba lagi.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
