import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../data/auth_repository.dart';

class LogoutButtonViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LogoutButtonViewModel(this._authRepository);

  Future<void> logout() async {
    await _authRepository.logout().then((value) => Modular.to.navigate('/'));
  }
}
