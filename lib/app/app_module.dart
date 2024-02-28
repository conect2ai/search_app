import 'package:flutter_modular/flutter_modular.dart';

import 'features/chat/module/chat_page_module.dart';
import 'features/home/interactor/bloc/homepage_bloc.dart';
import 'features/home/interactor/module/homepage_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.add<HomePageBloc>(HomePageBloc.new);
  }

  @override
  void routes(r) {
    r.module('/', module: HomePageModule());
    r.module('/chat',
        module: ChatPageModule(), transition: TransitionType.rightToLeft);
  }
}
