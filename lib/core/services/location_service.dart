import 'package:geolocator/geolocator.dart';

class LocationService {
  const LocationService();

  // Mengembalikan null bila izin ditolak, GPS mati, atau lokasi gagal didapat.
  Future<({double latitude, double longitude})?> currentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return (latitude: position.latitude, longitude: position.longitude);
    } on Exception {
      // Cuaca tetap tampil dengan lokasi default, jadi kegagalan lokasi tidak dilempar.
      return null;
    }
  }
}
