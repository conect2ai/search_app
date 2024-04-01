import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'core/entities/auth_user.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/interactor/module/auth_module.dart';
import 'features/chat/module/chat_page_module.dart';
import 'features/entrypoint/interactor/bloc/splash_page_bloc.dart';
import 'features/entrypoint/ui/splash_page.dart';
import 'features/home/interactor/bloc/homepage_bloc.dart';
import 'features/home/interactor/module/homepage_module.dart';
import 'services/secure_storage_service.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.add<HomePageBloc>(HomePageBloc.new);
    i.add<SplashPageBloc>(SplashPageBloc.new);
    i.addSingleton<AuthUser>(AuthUser.new);
    i.addSingleton<SecureStorageService>(SecureStorageService.new);
    i.addSingleton<AuthRepository>(AuthRepositoryImpl.new);
    i.add<Client>(http.Client.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const SplashPage(),
    );
    r.module('/auth', module: AuthModule());
    r.module('/home',
        module: HomePageModule(), transition: TransitionType.rightToLeft);
    r.module('/chat',
        module: ChatPageModule(), transition: TransitionType.rightToLeft);
  }
}
