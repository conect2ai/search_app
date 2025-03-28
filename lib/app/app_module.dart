import 'package:flutter_modular/flutter_modular.dart';

import 'core/entities/auth_user.dart';
import 'core/entities/car_info.dart';
import 'features/api_key/interactor/modules/check_api_key_module.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/interactor/module/auth_module.dart';
import 'features/chat/module/chat_page_module.dart';
import 'features/entrypoint/interactor/bloc/splash_page_bloc.dart';
import 'features/entrypoint/ui/splash_page.dart';
import 'features/home/interactor/bloc/homepage_bloc.dart';
import 'features/home/interactor/module/homepage_module.dart';
import 'features/manual/data/manual_repository.dart';
import 'features/manual/data/manual_repository_impl.dart';
import 'features/manual/interactor/blocs/manual_bloc.dart';
import 'features/manual/interactor/modules/manual_module.dart';
import 'features/menu/interactor/modules/menu_page_module.dart';
import 'features/report_problem/interactor/modules/report_problem_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.add<HomePageBloc>(HomePageBloc.new);
    i.add<SplashPageBloc>(SplashPageBloc.new);
    i.addSingleton<AuthUser>(AuthUser.new);
    i.addSingleton<CarInfo>(CarInfo.new);
    i.addSingleton<AuthRepository>(AuthRepositoryImpl.new);
    i.add<ManualRepository>(ManualRepositoryImpl.new);
    i.add<ManualBloc>(ManualBloc.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const SplashPage(),
    );
    r.module('/auth', module: AuthModule());
    r.module('/check-api-key', module: CheckApiKeyModule());
    r.module('/home',
        module: HomePageModule(), transition: TransitionType.rightToLeft);
    r.module('/manual-check',
        module: ManualCheckModule(), transition: TransitionType.rightToLeft);
    r.module('/chat',
        module: ChatPageModule(), transition: TransitionType.rightToLeft);
    r.module('/menu-page',
        module: MenuPageModule(), transition: TransitionType.rightToLeft);
    r.module('/report-problem',
        module: ReportProblemModule(), transition: TransitionType.rightToLeft);
  }
}
