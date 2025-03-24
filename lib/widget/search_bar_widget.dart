import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_test/controller/weather_controller.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final WeatherController weatherController = Get.find();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.isDarkMode;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: TextField(
            controller: _controller,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: "Enter city name",
              hintStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
              prefixIcon: Icon(Icons.location_city, color: isDarkMode ? Colors.white : Colors.black),
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: isDarkMode ? Colors.white : Colors.black),
                onPressed: () => weatherController.fetchWeatherByCity(_controller.text.trim()),
              ),
            ),
            onChanged: (value) => weatherController.fetchCitySuggestions(value),
            onSubmitted: (value) => weatherController.fetchWeatherByCity(value),
          ),
        ),

        Obx(() {
          if (weatherController.citySuggestions.isEmpty) return SizedBox();
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: Column(
              children: weatherController.citySuggestions.map((city) {
                return ListTile(
                  title: Text(city, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                  onTap: () {
                    weatherController.selectCityFromSuggestions(city);
                    _controller.text = city;
                  },
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}
