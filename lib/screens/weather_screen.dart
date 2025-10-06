import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/forecast_weather_card.dart';
import '../widgets/search_city_widget.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch weather data for default city when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [weatherProvider.getBackgroundColor(), weatherProvider.getBackgroundColor().withOpacity(0.8)],
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => weatherProvider.refreshWeather(),
                color: Colors.white,
                backgroundColor: weatherProvider.getBackgroundColor(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Search bar
                        const SearchCityWidget(),

                        const SizedBox(height: 20),

                        // Loading indicator
                        if (weatherProvider.isLoading)
                          const Center(
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                          ),

                        // Error message
                        if (weatherProvider.hasError)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.red.shade400.withAlpha(51),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.red.shade300.withAlpha(102), width: 1.5),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: Colors.white.withAlpha(51), shape: BoxShape.circle),
                                  child: const Icon(Icons.cloud_off_rounded, color: Colors.white, size: 40),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Không thể tải dữ liệu thời tiết',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Vui lòng kiểm tra kết nối mạng và thử lại',
                                  style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(230), height: 1.4),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () => weatherProvider.refreshWeather(),
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text('Thử lại'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withAlpha(51),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                    elevation: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Weather data
                        if (weatherProvider.hasData) ...[
                          // Current weather
                          const CurrentWeatherCard(),

                          const SizedBox(height: 20),

                          // Forecast weather
                          const ForecastWeatherCard(),

                          const SizedBox(height: 20),

                          // Thông tin cập nhật cuối
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(25),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white.withAlpha(51), width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.refresh_rounded, size: 18, color: Colors.white.withAlpha(179)),
                                const SizedBox(width: 10),
                                Text(
                                  'Kéo xuống để cập nhật dữ liệu',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withAlpha(179),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Trạng thái ban đầu
                        if (weatherProvider.status == WeatherStatus.initial)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(color: Colors.white.withAlpha(51), shape: BoxShape.circle),
                                  child: Icon(Icons.wb_sunny_outlined, size: 60, color: Colors.white.withAlpha(204)),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Dự báo thời tiết',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withAlpha(230),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tìm kiếm thành phố để xem thời tiết',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withAlpha(179),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
