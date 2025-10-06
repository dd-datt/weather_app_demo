import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.weatherapi.com/v1';
  static const String _apiKey = '7789e54e1a84440a924180131250610';

  Future<WeatherModel> getCurrentWeather(String city) async {
    final url = '$_baseUrl/current.json?key=$_apiKey&q=$city&aqi=yes';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load current weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching current weather: $e');
    }
  }

  Future<WeatherModel> getForecastWeather(String city, {int days = 3}) async {
    final url = '$_baseUrl/forecast.json?key=$_apiKey&q=$city&days=$days&aqi=yes';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load forecast weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching forecast weather: $e');
    }
  }

  Future<WeatherModel> getCompleteWeatherData(String city) async {
    try {
      return await getForecastWeather(city, days: 3);
    } catch (e) {
      throw Exception('Error fetching complete weather data: $e');
    }
  }
}
