import 'package:flutter_modular/flutter_modular.dart';

import '../../../../app_module.dart';
import '../../../home/interactor/module/homepage_module.dart';
import '../../ui/auth_screen.dart';
import '../../ui/login_screen.dart';
import '../../ui/recover_password_screen.dart';
import '../../ui/sign_up_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/login_bloc.dart';

class AuthModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<AuthBloc>(AuthBloc.new);
    i.addSingleton<LoginBloc>(LoginBloc.new);
  }

  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void routes(r) {
    r.child('/', child: (context) => const AuthScreen());
    r.child('/sign-up', child: (context) => const SignUpScreen());
    r.child('/login', child: (context) => const LoginScreen());
    r.child('/recover-password',
        child: (context) => const RecoverPasswordScreen());
    r.module('/home', module: HomePageModule());
  }
}
