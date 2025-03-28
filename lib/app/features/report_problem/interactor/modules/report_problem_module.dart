import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

import '../../../../app_module.dart';
import '../../../../blocs/loading_overlay_bloc.dart';
import '../../data/report_problem_repository.dart';
import '../../data/report_problem_repository_impl.dart';
import '../../ui/report_problem_page.dart';
import '../blocs/report_problem_bloc.dart';

class ReportProblemModule extends Module {
  @override
  void binds(i) {
    i.add<ReportProblemBloc>(ReportProblemBloc.new);
    i.add<ReportProblemRepository>(ReportProblemRepositoryImpl.new);
    i.addLazySingleton<LoadingOverlayBloc>(LoadingOverlayBloc.new);
    i.add<http.Client>(http.Client.new);
  }

  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void routes(r) {
    r.child('/', child: (context) => ReportProblemPage());
  }
}
