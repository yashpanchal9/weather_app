import 'package:flutter/material.dart';

class ForecastScreen extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  final Map<String, dynamic> forecast;

  const ForecastScreen({
    super.key,
    required this.weatherData,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather Forecast"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentWeatherCard(),
            const SizedBox(height: 20),
            const Text("Days Forecast", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildForecastList(),
          ],
        ),
      ),
    );
  }

  // Current weather card.
  Widget _buildCurrentWeatherCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${weatherData['current']['temp_c']}°C", style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                Text(weatherData['current']['condition']['text'], style: const TextStyle(fontSize: 18)),
              ],
            ),
            Image.network("https:${weatherData['current']['condition']['icon']}", width: 60, height: 60),
          ],
        ),
      ),
    );
  }

  // Days forecast list.
  Widget _buildForecastList() {
    return Expanded(
      child: ListView.builder(
        itemCount: forecast['forecastday'].length,
        itemBuilder: (context, index) {
          final day = forecast['forecastday'][index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Image.network("https:${day['day']['condition']['icon']}", width: 50, height: 50),
              title: Text(day['date'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${day['day']['condition']['text']}\nMin: ${day['day']['mintemp_c']}°C  Max: ${day['day']['maxtemp_c']}°C"),
            ),
          );
        },
      ),
    );
  }
}
