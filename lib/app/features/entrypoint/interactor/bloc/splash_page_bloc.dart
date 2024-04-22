import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/entities/auth_user.dart';
import '../../../../mixins/secure_storage.dart';

class SplashPageBloc with SecureStorage {
  AuthUser user;

  SplashPageBloc({required this.user});

  void loadUserInfo() async {
    final Map<String, String?> userInfo = {};
    userInfo['username'] = await readSecureData('username');
    userInfo['password'] = await readSecureData('password');
    userInfo['access_token'] = await readSecureData('access_token');
    userInfo['token_type'] = await readSecureData('token_type');
    user.updateToken(userInfo);
    user.updatedUsernameAndPassword(userInfo);

    Future.delayed(const Duration(seconds: 3), () => selectInitialRoute());
  }

  void selectInitialRoute() {
    if (user.token != null) {
      Modular.to.navigate('/home/');
    } else {
      Modular.to.navigate('/auth/');
    }
  }
}
