import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

import '../../../app_module.dart';
import '../../../blocs/loading_overlay_bloc.dart';
import '../data/search_repository.dart';
import '../data/search_repository_impl.dart';
import '../data/upload_manual_repository.dart';
import '../data/upload_manual_repository_impl.dart';
import '../data/vehicle_info_repository.dart';
import '../data/vehicle_info_repository_impl.dart';
import '../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../interactor/blocs/chatpage_inputs/chat_page_input_bloc.dart';
import '../interactor/blocs/manual_upload/manual_upload_bloc.dart';
import '../interactor/blocs/vehicle_form/vehicle_form_bloc.dart';
import '../ui/chat_page.dart';

class ChatPageModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<ChatPageBloc>(ChatPageBloc.new);
    i.addLazySingleton<ChatPageInputBloc>(ChatPageInputBloc.new);
    i.addLazySingleton<LoadingOverlayBloc>(LoadingOverlayBloc.new);
    i.addLazySingleton<VehicleFormBloc>(VehicleFormBloc.new);
    i.addLazySingleton<ManualUploadBloc>(ManualUploadBloc.new);
    i.add<UploadManualRepository>(UploadManualRepositoryImpl.new);
    i.add<VehicleInfoRepository>(VehicleInfoRepositoryImpl.new);
    i.add<SearchRepository>(SearchRepositoryImpl.new);
    i.add<http.Client>(http.Client.new);
  }

  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const ChatPage(),
    );
  }
}
