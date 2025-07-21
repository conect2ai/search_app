import 'dart:io';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/services/shared_preferences_service.dart';

class LanguagePreferencesServiceImpl implements SharedPreferencesService {
  SharedPreferences? _preferences;

  LanguagePreferencesServiceImpl();

  @override
  Future<bool> save(dynamic locale) async {
    _preferences = await SharedPreferences.getInstance();
    locale = locale as Locale;
    if (_preferences != null) {
      await _preferences!.setString('language', locale.languageCode);
    }
    return await _preferences?.setString('language', locale.languageCode) ??
        false;
  }

  @override
  Future<String?> getInfo(String key) async {
    _preferences = await SharedPreferences.getInstance();
    String? language;
    if (_preferences != null) {
      if (_preferences!.containsKey('language')) {
        language = _preferences!.getString('language');
      }
    } else {
      language = Platform.localeName.split('_').first;
    }
    return language;
  }
}
