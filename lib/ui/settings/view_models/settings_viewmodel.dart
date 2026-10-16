import 'dart:collection';

import 'package:flutter/foundation.dart';

/// ViewModel untuk layar Pengaturan (Settings).
/// Mengelola preferensi aksesibilitas suara (TTS), tampilan, dan konfigurasi cuaca.
class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({
    String initialSpeechRate = 'Normal (1.0x)',
    bool initialAutoPlay = true,
    String initialSpeechPitch = 'Normal',
    bool initialHighContrast = true,
    String initialTextSize = 'Normal',
    String initialCity = 'DKI Jakarta',
  }) : _speechRate = initialSpeechRate,
       _autoPlay = initialAutoPlay,
       _speechPitch = initialSpeechPitch,
       _highContrast = initialHighContrast,
       _textSize = initialTextSize,
       _selectedCity = initialCity;

  String _speechRate;
  bool _autoPlay;
  String _speechPitch;
  bool _highContrast;
  String _textSize;
  String _selectedCity;

  final List<String> _availableSpeechRates = const [
    'Lambat (0.75x)',
    'Normal (1.0x)',
    'Cepat (1.25x)',
  ];

  final List<String> _availableTextSizes = const [
    'Normal',
    'Besar',
    'Sangat Besar',
  ];

  final List<String> _availableCities = const [
    'DKI Jakarta',
    'Bandung',
    'Surabaya',
    'Yogyakarta',
    'Medan',
  ];

  String get speechRate => _speechRate;
  bool get autoPlay => _autoPlay;
  String get speechPitch => _speechPitch;
  bool get highContrast => _highContrast;
  String get textSize => _textSize;
  String get selectedCity => _selectedCity;

  UnmodifiableListView<String> get availableSpeechRates =>
      UnmodifiableListView(_availableSpeechRates);
  UnmodifiableListView<String> get availableTextSizes =>
      UnmodifiableListView(_availableTextSizes);
  UnmodifiableListView<String> get availableCities =>
      UnmodifiableListView(_availableCities);

  void setSpeechRate(String rate) {
    if (_speechRate == rate) return;
    _speechRate = rate;
    notifyListeners();
  }

  void toggleAutoPlay(bool value) {
    if (_autoPlay == value) return;
    _autoPlay = value;
    notifyListeners();
  }

  void setSpeechPitch(String pitch) {
    if (_speechPitch == pitch) return;
    _speechPitch = pitch;
    notifyListeners();
  }

  void toggleHighContrast(bool value) {
    if (_highContrast == value) return;
    _highContrast = value;
    notifyListeners();
  }

  void setTextSize(String size) {
    if (_textSize == size) return;
    _textSize = size;
    notifyListeners();
  }

  void setSelectedCity(String city) {
    if (_selectedCity == city) return;
    _selectedCity = city;
    notifyListeners();
  }
}
