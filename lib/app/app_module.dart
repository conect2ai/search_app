import 'package:flutter_modular/flutter_modular.dart';

import 'features/chat/module/chat_page_module.dart';
import 'features/home/interactor/bloc/homepage_bloc.dart';
import 'features/home/ui/homepage.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.add<HomePageBloc>(HomePageBloc.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());
    r.module('/chat',
        module: ChatPageModule(), transition: TransitionType.rightToLeft);
  }
}
