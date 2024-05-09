import 'package:flutter_modular/flutter_modular.dart';

import '../../../../app_module.dart';
import '../../ui/homepage.dart';

class HomePageModule extends Module {
  @override
  void binds(i) {}

  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());
  }
}
