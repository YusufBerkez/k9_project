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
