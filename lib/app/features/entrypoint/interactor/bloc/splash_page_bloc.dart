import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/entities/auth_user.dart';
import '../../../../services/secure_storage_service.dart';

class SplashPageBloc {
  AuthUser user;
  SecureStorageService secureStorage;

  SplashPageBloc({required this.user, required this.secureStorage});

  void loadUserInfo() async {
    final Map<String, String?> userInfo = {};
    userInfo['username'] = await secureStorage.readSecureData('username');
    userInfo['password'] = await secureStorage.readSecureData('password');
    userInfo['access_token'] =
        await secureStorage.readSecureData('access_token');
    userInfo['token_type'] = await secureStorage.readSecureData('token_type');
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
