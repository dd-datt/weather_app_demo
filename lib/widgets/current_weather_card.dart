import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        if (!weatherProvider.hasData) {
          return const SizedBox.shrink();
        }

        final weather = weatherProvider.weatherData!;
        final current = weather.current;
        final location = weather.location;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withAlpha(76), width: 1.5),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Vị trí
              Text(
                '${location.name}, ${location.country}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Biểu tượng và nhiệt độ thời tiết
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Biểu tượng thời tiết
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Center(child: Text(weatherProvider.getWeatherEmoji(), style: const TextStyle(fontSize: 45))),
                  ),
                  const SizedBox(width: 24),

                  // Nhiệt độ
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${current.tempC.round()}°C',
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 0.9,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cảm nhận ${current.feelslikeC.round()}°C',
                        style: TextStyle(fontSize: 15, color: Colors.white.withAlpha(204), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Mô tả thời tiết
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white.withAlpha(25), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  current.condition.text,
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 28),

              // Chi tiết thời tiết
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white.withAlpha(25), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherDetail(icon: '💨', label: 'Tốc độ gió', value: '${current.windKph.round()} km/h'),
                    _buildWeatherDetail(icon: '💧', label: 'Độ ẩm', value: '${current.humidity}%'),
                    _buildWeatherDetail(icon: '☀️', label: 'Chỉ số UV', value: current.uv.toString()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeatherDetail({required String icon, required String label, required String value}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withAlpha(25), shape: BoxShape.circle),
          child: Text(icon, style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(204), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ],
    );
  }
}
