import 'package:weather_test/model/weather_model.dart';
import 'api_service.dart';
import '../model/forecast.dart';

class WeatherRepository {
  final ApiService apiService;

  WeatherRepository({required this.apiService});

  // Fetches current weather data.
  Future<Weather> getCurrentWeather({double? lat, double? lon, String? city}) async {
    final response = await apiService.fetchWeatherData(lat: lat, lon: lon, city: city);
    if (response?['location'] != null && response?['current'] != null) {
      return Weather.fromJson(response!);
    }
    throw Exception("Weather API response is missing required fields.");
  }

  // Fetches day weather forecast.
  Future<Forecast> getWeatherForecast({double? lat, double? lon, String? city}) async {
    final response = await apiService.fetchForecastData(lat: lat, lon: lon, city: city);
    if (response?['forecast'] != null) {
      return Forecast.fromJson(response!);
    }
    throw Exception("Forecast API response is missing required fields.");
  }
}
