import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.weatherapi.com/v1";
  final String apiKey = "401a6077896c469796c172227252203";

  Future<List<String>> getCitySuggestions(String query) async {
    if (query.isEmpty) return [];

    final url = "$baseUrl/search.json?key=$apiKey&q=$query";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((city) => city['name'] as String).toList();
    } else {
      return [];
    }
  }

  //Fetches current weather data based on either city name or latitude & longitude.
  Future<Map<String, dynamic>?> fetchWeatherData({double? lat, double? lon, String? city}) async {
    try {
      String url = city != null
          ? "$baseUrl/current.json?key=$apiKey&q=$city"
          : "$baseUrl/current.json?key=$apiKey&q=$lat,$lon";

      // Send GET request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log("API Error: ${response.body}");
        return null;
      }
    } catch (e) {
      log("Network Error: $e");
      return null;
    }
  }

  // Fetches day weather forecast based on either city name or lat & long.
  Future<Map<String, dynamic>?> fetchForecastData({double? lat, double? lon, String? city}) async {
    try {
      // Construct API URL based on user input
      String url = city != null
          ? "$baseUrl/forecast.json?key=$apiKey&q=$city&days=5"
          : "$baseUrl/forecast.json?key=$apiKey&q=$lat,$lon&days=5";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log("Forecast API Error: ${response.body}");
        return null;
      }
    } catch (e) {
      log("Network Error: $e");
      return null;
    }
  }


}
