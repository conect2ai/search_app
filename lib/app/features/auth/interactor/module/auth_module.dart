import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../home/interactor/module/homepage_module.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_repository_impl.dart';
import '../../ui/auth_page.dart';
import '../bloc/auth_bloc.dart';

class AuthModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<AuthBloc>(AuthBloc.new);
    i.add<AuthRepository>(AuthRepositoryImpl.new);
    i.add<Client>(http.Client.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => AuthPage());
    r.module('/home', module: HomePageModule());
  }
}
