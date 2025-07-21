import 'package:flutter/material.dart';

import '../../data/auth_repository.dart';
import '../../domain/exceptions/signup_failure_exception.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  SignUpViewModel(this._authRepository);

  Future<void> signUp(String email) async {
    try {
      await _authRepository.signUp(email);
    } on SignUpFailureException catch (_) {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}
