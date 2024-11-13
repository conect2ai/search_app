import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/entities/auth_user.dart';
import '../../data/auth_repository.dart';
import '../events/auth_event.dart';
import '../states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthUser userAuth = AuthUser();
  AuthRepository authRepository;
  SharedPreferences? _prefs;

  AuthBloc({required this.authRepository}) : super(LoginState()) {
    on<SwitchToLoginEvent>((event, emit) =>
        emit(LoginState(username: event.username, password: event.password)));
    on<SwitchToSignUpEvent>((event, emit) =>
        emit(SignUpState(username: event.username, password: event.password)));
  }

  Future<void> login(Map<String, String> formData) async {
    await authRepository.login(formData);
  }

  Future<void> signUp(String formData) async {
    await authRepository.signUp(formData);
  }

  Future<void> logout() async {
    await authRepository.logout();
    Modular.to.navigate('/');
  }

  Future<void> recoverPassword(String email) async {
    await authRepository.recoverPassword(email);
  }

  Future<String?> getLanguage() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs != null) {
      if (_prefs!.containsKey('language')) {
        final language = _prefs!.getString('language');
        return language;
      }
    }
    return null;
  }

  Future<void> setLanguage(Locale locale) async {
    if (_prefs != null) {
      await _prefs!.setString('language', locale.languageCode);
    }
  }
}
