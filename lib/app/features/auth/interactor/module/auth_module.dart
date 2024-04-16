import 'package:flutter_modular/flutter_modular.dart';

import '../../../../app_module.dart';
import '../../../home/interactor/module/homepage_module.dart';
import '../../ui/auth_page.dart';
import '../bloc/auth_bloc.dart';

class AuthModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<AuthBloc>(AuthBloc.new);
  }

  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void routes(r) {
    r.child('/', child: (context) => AuthPage());
    r.module('/home', module: HomePageModule());
  }
}
