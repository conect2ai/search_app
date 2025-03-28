import 'package:flutter_modular/flutter_modular.dart';

import '../../../report_problem/interactor/modules/report_problem_module.dart';
import '../../ui/menu_page.dart';

class MenuPageModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const MenuPage());
    r.module('/report-problem', module: ReportProblemModule());
  }
}
