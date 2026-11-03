import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<void> loadTheme() async {
    final isDark = await _prefs.getBool('isDark') ?? false;
    value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final isDark = value == ThemeMode.dark;

    value = isDark ? ThemeMode.light : ThemeMode.dark;

    await _prefs.setBool('isDark', !isDark);
  }
}
