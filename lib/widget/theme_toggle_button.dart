import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_test/services/theme_service.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find();

    return GetBuilder<ThemeService>(
      builder: (_) {
        return IconButton(
          icon: Icon(themeService.isDarkMode.value ? Icons.dark_mode : Icons.light_mode),
          onPressed: () {
            themeService.toggleTheme();
          },
        );
      },
    );
  }
}
