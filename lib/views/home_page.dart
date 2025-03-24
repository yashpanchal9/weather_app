import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_test/widget/search_bar_widget.dart';
import 'package:weather_test/widget/theme_toggle_button.dart';
import 'package:weather_test/widget/weather_card.dart';
import 'package:weather_test/controller/weather_controller.dart';
import 'package:weather_test/services/theme_service.dart';

class HomePage extends StatelessWidget {
  final WeatherController weatherController = Get.find();
  final ThemeService themeService = Get.find();

  HomePage({super.key}) {
    weatherController.fetchWeatherForCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeService>(
      builder: (_) {
        bool isDarkMode = themeService.isDarkMode.value;
        Color textColor = isDarkMode ? Colors.white : Colors.black;

        return Scaffold(
          appBar: AppBar(
            title: Text("Weather App", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            actions: [ThemeToggleButton()],
          ),
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchScreen(),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Obx(() {
                      if (weatherController.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (weatherController.errorMessage.value.isNotEmpty) {
                        return Center(
                          child: Text(weatherController.errorMessage.value,
                              style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                        );
                      }
                      if (weatherController.weatherData.value != null &&
                          weatherController.forecastData.value != null) {
                        return WeatherCard(
                          weather: weatherController.weatherData.value!,
                          forecast: weatherController.forecastData.value!.forecastDays,
                        );
                      }
                      return Center(
                        child: Text("Search for a city or use location.",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
