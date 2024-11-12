import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/entities/auth_user.dart';
import '../../data/auth_repository.dart';

class AuthBloc {
  final AuthRepository _authRepository;
  final AuthUser _user;
  AuthBloc(
    this._authRepository,
    this._user,
  );

  Future<void> login(Map<String, String> userInfo) async {
    try {
      await _authRepository.login(userInfo).then((_) async {
        if (_user.token != null) {
          Modular.to.navigate('/home');
        }
      });
    } on HttpException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email) async {
    try {
      await _authRepository.signUp(email);
    } on HttpException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> recoverPassword(String email) async {
    try {
      await _authRepository.recoverPassword(email);
    } on HttpException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
