import 'package:flutter/material.dart';

import '../../data/auth_repository.dart';
import '../../data/exceptions/server_exception.dart';
import '../../domain/exceptions/invalid_credentials_exceptiion.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isButtonLoading = false;
  bool _isLoginButtonEnabled = true;

  final AuthRepository _authRepository;

  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  bool get isButtonLoading => _isButtonLoading;
  bool get isLoginButtonEnabled => _isLoginButtonEnabled;

  Future<void> login(Map<String, String> credentials) async {
    _isButtonLoading = true;
    notifyListeners();
    try {
      _isLoginButtonEnabled = false;
      await _authRepository.login(credentials);
    } on InvalidCredentialsException catch (_) {
      _isLoginButtonEnabled = true;
      throw InvalidCredentialsException('_');
    } catch (_) {
      _isLoginButtonEnabled = true;
      throw ServerException('_');
    } finally {
      _isButtonLoading = false;
      _isLoginButtonEnabled = true;
      notifyListeners();
    }
  }
}
