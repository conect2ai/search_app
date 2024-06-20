import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/entities/auth_user.dart';
import '../../../../mixins/secure_storage.dart';
import '../../../auth/data/auth_repository.dart';

class SplashPageBloc with SecureStorage {
  AuthUser _user;
  AuthRepository _authRepository;

  SplashPageBloc(this._user, this._authRepository);

  void loadUserInfo() async {
    final Map<String, String?> userInfo = {
      'access_token': null,
      'token_type': null
    };
    userInfo['username'] = await readSecureData('username');
    userInfo['password'] = await readSecureData('password');
    userInfo['access_token'] = await readSecureData('access_token');
    userInfo['token_type'] = await readSecureData('token_type');
    _user.updatedUsernameAndPassword(userInfo);
    _user.updateToken(userInfo);

    Future.delayed(const Duration(seconds: 3), () => _checkIfTokenIsValid());
  }

  Future<void> _checkIfTokenIsValid() async {
    try {
      await _authRepository.checkIfTokenIsValid();
    } on HttpException catch (_) {
      _user.updateToken({'access_token': null, 'token_type': null});
    } catch (_) {
      rethrow;
    } finally {
      selectInitialRoute();
    }
  }

  void selectInitialRoute() {
    if (_user.token != null) {
      Modular.to.navigate('/home/');
    } else {
      Modular.to.navigate('/auth/');
    }
  }
}
