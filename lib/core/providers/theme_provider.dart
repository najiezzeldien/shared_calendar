import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends Notifier<ThemeMode> {
  static const _themePrefsKey = 'theme_mode';

  @override
  ThemeMode build() {
    // Load theme immediately after initialization
    Future.microtask(() => _loadTheme());
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeIndex = prefs.getInt(_themePrefsKey);
    if (savedThemeIndex != null) {
      state = ThemeMode.values[savedThemeIndex];
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePrefsKey, mode.index);
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(newMode);
  }
}

final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(
  () {
    return ThemeController();
  },
);
