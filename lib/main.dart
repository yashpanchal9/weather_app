import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weather_test/services/api_service.dart';
import 'package:weather_test/services/weather_repository.dart';
import 'package:weather_test/views/home_page.dart';
import 'package:weather_test/services/theme_service.dart';
import 'package:weather_test/controller/weather_controller.dart';
import 'package:weather_test/services/location_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // Dependency Injection
  Get.put(ThemeService());
  Get.put(LocationService());
  Get.put(ApiService());
  Get.put(WeatherRepository(apiService: Get.find()));
  Get.put(WeatherController(weatherRepository: Get.find(), locationService: Get.find()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Get.find<ThemeService>().theme,
      home: HomePage(),
    );
  }
}
