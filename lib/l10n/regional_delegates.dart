import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// A delegate that provides MaterialLocalizations for languages not natively 
/// supported by GlobalMaterialLocalizations by falling back to Urdu (ur).
class RegionalMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const RegionalMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['pa', 'sd', 'bal'].contains(locale.languageCode);

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Fall back to Urdu for Material-specific strings (buttons, tooltips, etc.)
    return await GlobalMaterialLocalizations.delegate.load(const Locale('ur', 'PK'));
  }

  @override
  bool shouldReload(RegionalMaterialLocalizationsDelegate old) => false;
}

/// A delegate for CupertinoLocalizations fallback
class RegionalCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const RegionalCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['pa', 'sd', 'bal'].contains(locale.languageCode);

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    return await GlobalCupertinoLocalizations.delegate.load(const Locale('ur', 'PK'));
  }

  @override
  bool shouldReload(RegionalCupertinoLocalizationsDelegate old) => false;
}
