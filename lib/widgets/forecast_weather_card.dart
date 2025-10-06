import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../models/weather_model.dart';

class ForecastWeatherCard extends StatelessWidget {
  const ForecastWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        if (!weatherProvider.hasData || weatherProvider.weatherData!.forecast == null) {
          return const SizedBox.shrink();
        }

        final forecast = weatherProvider.weatherData!.forecast!;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withAlpha(76), width: 1.5),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withAlpha(25), shape: BoxShape.circle),
                    child: const Text('📅', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Dự báo 3 ngày tới',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ...forecast.forecastday.map((day) => _buildForecastItem(day)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForecastItem(ForecastDay forecastDay) {
    final date = DateTime.parse(forecastDay.date);
    final dayName = _getDayName(date);
    final emoji = _getWeatherEmoji(forecastDay.day.condition.text);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(51), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dòng đầu: Ngày + Icon + Nhiệt độ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tên ngày
              Expanded(
                flex: 2,
                child: Text(
                  dayName,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),

              // Biểu tượng thời tiết
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withAlpha(25), shape: BoxShape.circle),
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),

              // Nhiệt độ
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: Colors.white.withAlpha(25), borderRadius: BorderRadius.circular(15)),
                child: Text(
                  '${forecastDay.day.avgtempC.round()}°C',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Dòng thứ hai: Mô tả thời tiết
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withAlpha(15), borderRadius: BorderRadius.circular(12)),
            child: Text(
              forecastDay.day.condition.text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withAlpha(204),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);

    final difference = compareDate.difference(today).inDays;

    switch (difference) {
      case 0:
        return 'Hôm nay';
      case 1:
        return 'Ngày mai';
      case 2:
        return 'Ngày kia';
      default:
        final weekdays = ['CN', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
        return weekdays[date.weekday % 7];
    }
  }

  String _getWeatherEmoji(String condition) {
    final conditionLower = condition.toLowerCase();

    if (conditionLower.contains('sunny') || conditionLower.contains('clear')) {
      return '☀️';
    } else if (conditionLower.contains('rain') || conditionLower.contains('drizzle')) {
      return '🌧️';
    } else if (conditionLower.contains('cloud') || conditionLower.contains('overcast')) {
      return '☁️';
    } else if (conditionLower.contains('snow')) {
      return '❄️';
    } else if (conditionLower.contains('mist') || conditionLower.contains('fog')) {
      return '🌫️';
    } else if (conditionLower.contains('partly cloudy')) {
      return '⛅';
    } else {
      return '🌤️';
    }
  }
}
