import 'package:intl/intl.dart'; // ✅ Import for date formatting

class Weather {
  final String cityName;
  final String dayName;
  final double temperature;
  final String condition;
  final String icon;

  Weather({
    required this.cityName,
    required this.dayName,
    required this.temperature,
    required this.condition,
    required this.icon,
  });

  // Convert to JSON (For Caching)
  Map<String, dynamic> toJson() => {
    "cityName": cityName,
    "dayName": dayName,
    "temperature": temperature,
    "condition": condition,
    "icon": icon,
  };

  //Factory method for Current Weather
  factory Weather.fromJson(Map<String, dynamic> json) {
    final location = json['location'] ?? {};
    final current = json['current'] ?? {};
    final condition = current['condition'] ?? {};

    return Weather(
      cityName: location['name'] ?? "Unknown City",
      dayName: "Today",
      temperature: (current['temp_c'] ?? 0.0).toDouble(),
      condition: condition['text'] ?? "Unknown",
      icon: condition['icon'] ?? "",
    );
  }

  // Factory method for Day Forecast
  factory Weather.fromForecastJson(Map<String, dynamic> json, String city) {
    return Weather(
      cityName: city,
      dayName: DateFormat('EEEE').format(DateTime.parse(json['date'])),
      temperature: (json['day']['avgtemp_c'] ?? 0.0).toDouble(),
      condition: json['day']['condition']?['text'] ?? "Unknown",
      icon: json['day']['condition']?['icon'] ?? "",
    );
  }
}
