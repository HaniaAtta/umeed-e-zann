import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  Locale _locale = const Locale('en', 'US');

  Locale get locale => _locale;

  LocaleService() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      final parts = localeCode.split('_');
      if (parts.length == 2) {
        _locale = Locale(parts[0], parts[1]);
      } else {
        _locale = Locale(parts[0]);
      }
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, '${locale.languageCode}_${locale.countryCode ?? ''}');
    notifyListeners();
  }

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('ur', 'PK'), // Urdu (Pakistan)
    Locale('pa', 'PK'), // Punjabi (Pakistan)
    Locale('tr', 'TR'), // Turkish
    Locale('sd', 'PK'), // Sindhi (Pakistan)
    Locale('bal', 'PK'), // Balochi (Pakistan)
  ];

  // Language names for display
  static const Map<String, String> languageNames = {
    'en': 'English',
    'ur': 'اردو',
    'pa': 'ਪੰਜਾਬੀ',
    'tr': 'Türkçe',
    'sd': 'سنڌي',
    'bal': 'بلوچی',
  };
}

