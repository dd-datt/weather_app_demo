class WeatherModel {
  final Location location;
  final Current current;
  final Forecast? forecast;

  WeatherModel({required this.location, required this.current, this.forecast});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
      forecast: json['forecast'] != null ? Forecast.fromJson(json['forecast']) : null,
    );
  }
}

class Location {
  final String name;
  final String country;

  Location({required this.name, required this.country});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(name: json['name'], country: json['country']);
  }
}

class Current {
  final double tempC;
  final double feelslikeC;
  final Condition condition;
  final double windKph;
  final int humidity;
  final double uv;

  Current({
    required this.tempC,
    required this.feelslikeC,
    required this.condition,
    required this.windKph,
    required this.humidity,
    required this.uv,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      tempC: json['temp_c'].toDouble(),
      feelslikeC: json['feelslike_c'].toDouble(),
      condition: Condition.fromJson(json['condition']),
      windKph: json['wind_kph'].toDouble(),
      humidity: json['humidity'],
      uv: json['uv'].toDouble(),
    );
  }
}

class Condition {
  final String text;
  final String icon;

  Condition({required this.text, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(text: json['text'], icon: json['icon']);
  }
}

class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    var list = json['forecastday'] as List;
    List<ForecastDay> forecastdayList = list.map((i) => ForecastDay.fromJson(i)).toList();

    return Forecast(forecastday: forecastdayList);
  }
}

class ForecastDay {
  final String date;
  final Day day;

  ForecastDay({required this.date, required this.day});

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(date: json['date'], day: Day.fromJson(json['day']));
  }
}

class Day {
  final double avgtempC;
  final Condition condition;

  Day({required this.avgtempC, required this.condition});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(avgtempC: json['avgtemp_c'].toDouble(), condition: Condition.fromJson(json['condition']));
  }
}
