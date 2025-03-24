import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather_test/services/location_service.dart';
import 'package:weather_test/model/weather_model.dart';
import '../model/forecast.dart';
import '../services/weather_repository.dart';

class WeatherController extends GetxController with SingleGetTickerProviderMixin {
  final WeatherRepository weatherRepository;
  final LocationService locationService;
  final box = GetStorage();

  var weatherData = Rxn<Weather>();
  var forecastData = Rxn<Forecast>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var cityName = ''.obs;
  var isCelsius = true.obs;
  var citySuggestions = <String>[].obs;

  late AnimationController animationController;
  late Animation<double> animation;

  WeatherController({required this.weatherRepository, required this.locationService});

  @override
  void onInit() {
    super.onInit();
    isCelsius.value = box.read("isCelsius") ?? true;
    _setupAnimation();
  }

  // Weather Icon Animation
  void _setupAnimation() {
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    animation = Tween<double>(begin: 0.8, end: 1.2).animate(animationController);
  }

  // Get Weather Icon Based on Condition
  IconData getWeatherIcon(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains("sunny")) return Icons.wb_sunny;
    if (condition.contains("rain")) return Icons.beach_access;
    if (condition.contains("cloud")) return Icons.wb_cloudy;
    if (condition.contains("storm")) return Icons.flash_on;
    return Icons.device_thermostat;
  }

  // Show No Internet Dialog
  Future<void> _showNoInternetDialog() async {
    Get.defaultDialog(
      title: "No Internet",
      middleText: "Please check your internet connection and try again.",
      confirm: ElevatedButton(onPressed: () => Get.back(), child: const Text("OK")),
    );
  }

  // Check Internet Connection
  Future<bool> _hasInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Toggle Temperature Unit
  void toggleTemperatureUnit() {
    isCelsius.value = !isCelsius.value;
    box.write("isCelsius", isCelsius.value);
  }

  // Convert Temperature Based on Selected Unit
  double convertTemperature(double tempC) => isCelsius.value ? tempC : (tempC * 9 / 5) + 32;

  // Fetch Weather for Current Location
  Future<void> fetchWeatherForCurrentLocation() async {
    if (!await _hasInternet()) {
      _showNoInternetDialog();
      return;
    }

    isLoading.value = true;
    try {
      await locationService.getCurrentLocation();
      double lat = locationService.latitude ?? 21.1702;
      double lon = locationService.longitude ?? 72.8311;

      var weather = await weatherRepository.getCurrentWeather(lat: lat, lon: lon);
      weatherData.value = weather;
      cityName.value = weather.cityName;

      var forecast = await weatherRepository.getWeatherForecast(lat: lat, lon: lon);
      forecastData.value = forecast;
    } catch (e) {
      errorMessage.value = "Failed to fetch weather data.";
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch City Suggestions
  Future<void> fetchCitySuggestions(String query) async {
    if (query.isEmpty) return;
    final suggestions = await weatherRepository.apiService.getCitySuggestions(query);
    citySuggestions.assignAll(suggestions);
  }

  // Fetch Weather by City
  Future<void> fetchWeatherByCity(String city) async {
    if (!await _hasInternet()) {
      _showNoInternetDialog();
      return;
    }

    isLoading.value = true;
    try {
      var weather = await weatherRepository.getCurrentWeather(city: city);
      weatherData.value = weather;
      cityName.value = weather.cityName;
      citySuggestions.clear();

      var forecast = await weatherRepository.getWeatherForecast(city: city);
      forecastData.value = forecast;
    } catch (e) {
      errorMessage.value = "Failed to fetch weather data for $city.";
    } finally {
      isLoading.value = false;
    }
  }

  //  City Selection
  void selectCityFromSuggestions(String city) {
    fetchWeatherByCity(city);
  }
}
