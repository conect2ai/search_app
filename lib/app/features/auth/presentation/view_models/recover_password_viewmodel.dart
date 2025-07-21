import 'package:flutter/material.dart';

import '../../data/auth_repository.dart';

class RecoverPasswordViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  RecoverPasswordViewModel(this._authRepository);

  Future<void> recoverPassword(String email) async {
    await _authRepository.recoverPassword(email);
  }
}
