import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ThemeNotifier - Karanlık mod durumunu yöneten Notifier
/// SharedPreferences ile kalıcı depolama sağlar
class ThemeNotifier extends Notifier<bool> {
  static const String _key = 'isDarkMode';

  @override
  bool build() {
    _loadTheme();
    return false; // Default value
  }

  /// Kaydedilmiş tema tercihini yükle
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  /// Karanlık mod durumunu değiştir ve kaydet
  Future<void> toggleTheme(bool isDark) async {
    state = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark);
  }
}

/// Global tema sağlayıcısı - Clean Architecture için core katmanında
final themeProvider = NotifierProvider<ThemeNotifier, bool>(() {
  return ThemeNotifier();
});

extension ThemeRef on WidgetRef {
  // 1. Okumak için kısa yol (ref.isDark)
  bool get isDark => watch(themeProvider);

  // 2. Değiştirmek için kısa yol (ref.toggleTheme())
  // Senin yazdığın fonksiyon parametre (bool) istiyordu,
  // burada otomatik olarak "mevcut durumun tersini" yolluyoruz.
  void toggleTheme() {
    final notifier = read(themeProvider.notifier);
    final isCurrentlyDark = read(themeProvider);
    notifier.toggleTheme(!isCurrentlyDark);
  }
}

extension ThemeContext on WidgetRef {
  ThemeData get theme => Theme.of(context);
}
