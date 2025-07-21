import 'package:flutter/material.dart';

import '../../../../../streams/general_stream.dart';
import '../../../../shared/domain/repositories/shared_preferences_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final SharedPreferencesRepository _sharedPreferencesRepository;

  AuthViewModel(
      {required SharedPreferencesRepository sharedPreferencesRepository})
      : _sharedPreferencesRepository = sharedPreferencesRepository;

  Future<void> getLanguage() async {
    final language = await _sharedPreferencesRepository.getInfo('language');
    GeneralStream.languageStream
        .add(language != null ? Locale(language) : const Locale('en'));
  }

  Future<bool> setLanguage(Locale locale) async {
    GeneralStream.languageStream.add(locale);
    return await _sharedPreferencesRepository.save(locale);
  }
}
