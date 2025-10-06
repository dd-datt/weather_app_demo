import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  WeatherModel? _weatherData;
  WeatherStatus _status = WeatherStatus.initial;
  String _errorMessage = '';
  String _currentCity = 'Hồ Chí Minh';

  WeatherModel? get weatherData => _weatherData;
  WeatherStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get currentCity => _currentCity;

  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasError => _status == WeatherStatus.error;
  bool get hasData => _status == WeatherStatus.loaded && _weatherData != null;

  Future<void> fetchWeatherData([String? city]) async {
    final searchCity = city ?? _currentCity;
    _status = WeatherStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _weatherData = await _weatherService.getCompleteWeatherData(searchCity);
      _currentCity = searchCity;
      _status = WeatherStatus.loaded;
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.toString();
      _weatherData = null;
    }

    notifyListeners();
  }

  Future<void> refreshWeather() async {
    await fetchWeatherData(_currentCity);
  }

  void updateCity(String city) {
    if (city.isNotEmpty && city != _currentCity) {
      fetchWeatherData(city);
    }
  }

  Color getBackgroundColor() {
    if (_weatherData == null) return Colors.blue.shade400;

    final condition = _weatherData!.current.condition.text.toLowerCase();

    if (condition.contains('sunny') || condition.contains('clear')) {
      return Colors.orange.shade400;
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return Colors.blue.shade600;
    } else if (condition.contains('cloud') || condition.contains('overcast')) {
      return Colors.grey.shade500;
    } else if (condition.contains('snow')) {
      return Colors.blue.shade200;
    } else if (condition.contains('mist') || condition.contains('fog')) {
      return Colors.grey.shade400;
    } else {
      return Colors.blue.shade400;
    }
  }

  String getWeatherEmoji() {
    if (_weatherData == null) return '🌤️';

    final condition = _weatherData!.current.condition.text.toLowerCase();

    if (condition.contains('sunny') || condition.contains('clear')) {
      return '☀️';
    } else if (condition.contains('rain')) {
      return '🌧️';
    } else if (condition.contains('cloud')) {
      return '☁️';
    } else if (condition.contains('snow')) {
      return '❄️';
    } else if (condition.contains('mist') || condition.contains('fog')) {
      return '🌫️';
    } else {
      return '🌤️';
    }
  }
}
