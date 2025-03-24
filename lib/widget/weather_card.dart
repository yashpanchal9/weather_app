import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_test/model/weather_model.dart';
import '../controller/weather_controller.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final List<Weather> forecast;
  final WeatherController weatherController = Get.find();

  WeatherCard({super.key, required this.weather, required this.forecast});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.isDarkMode;
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      shadowColor: isDarkMode ? Colors.white30 : Colors.black26,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: isDarkMode ? Colors.grey[900] : Colors.white),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCityName(textColor),
            const SizedBox(height: 5),
            _buildWeatherIcon(),
            const SizedBox(height: 5),
            _buildTemperature(textColor),
            const SizedBox(height: 10),
            _buildConditionText(textColor),
            Divider(color: isDarkMode ? Colors.white70 : Colors.black38),
            _buildForecastSection(textColor),
          ],
        ),
      ),
    );
  }

  // City Name
  Widget _buildCityName(Color textColor) => Text(
    weather.cityName,
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
  );

  // Animated Weather Icon
  Widget _buildWeatherIcon() => ScaleTransition(
    scale: weatherController.animation,
    child: Icon(weatherController.getWeatherIcon(weather.condition), size: 50, color: Get.isDarkMode ? Colors.white : Colors.black),
  );

  // Temperature
  Widget _buildTemperature(Color textColor) => Obx(() {
    double convertedTemp = weatherController.convertTemperature(weather.temperature);
    return Text(
      "${convertedTemp.toStringAsFixed(1)}° ${weatherController.isCelsius.value ? 'C' : 'F'}",
      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: textColor),
    );
  });

  // Weather Condition
  Widget _buildConditionText(Color textColor) => Text(
    weather.condition,
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: textColor.withOpacity(0.7)),
  );

  // Day Forecast Section
  Widget _buildForecastSection(Color textColor) => Column(
    children: [
      Text("Day Forecast", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
      const SizedBox(height: 10),
      Column(
        children: forecast.map((day) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(weatherController.getWeatherIcon(day.condition), size: 20, color: textColor),
                    const SizedBox(width: 5),
                    Text(day.dayName, style: TextStyle(fontSize: 16, color: textColor)),
                  ],
                ),
                Text("${day.temperature.toStringAsFixed(1)}°C",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
              ],
            ),
          );
        }).toList(),
      ),
    ],
  );
}
