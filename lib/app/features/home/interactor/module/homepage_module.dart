import 'package:flutter_modular/flutter_modular.dart';

import '../../ui/homepage.dart';

class HomePageModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());
  }
}
