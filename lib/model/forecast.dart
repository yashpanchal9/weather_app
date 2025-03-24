import 'weather_model.dart';

class Forecast {
  final List<Weather> forecastDays;

  Forecast({required this.forecastDays});

  // Convert Forecast object to JSON
  Map<String, dynamic> toJson() => {
    "forecastDays": forecastDays.map((day) => day.toJson()).toList(),
  };

  // Convert JSON to Forecast object
  factory Forecast.fromJson(Map<String, dynamic> json) {
    final days = (json['forecast']?['forecastday'] as List?) ?? [];
    final city = json['location']?['name'] ?? "Unknown City";
    final today = DateTime.now();

    final filteredDays = days.where((day) => DateTime.parse(day['date']).isAfter(today)).take(5);

    return Forecast(
      forecastDays: filteredDays.map((day) => Weather.fromForecastJson(day, city)).toList(),
    );
  }
}
