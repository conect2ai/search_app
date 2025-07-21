import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

import '../../../app_module.dart';
import '../../../blocs/loading_overlay_bloc.dart';
import '../../../shared/data/repositories/shared_preferences_repository_impl.dart';
import '../../../shared/data/services/language_preferences_service_impl.dart';
import '../../../shared/domain/repositories/shared_preferences_repository.dart';
import '../../../shared/domain/services/shared_preferences_service.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/external/repositories/auth_repository_impl.dart';
import '../../auth/data/external/services/api/auth_api_client_impl.dart';
import '../../auth/domain/infra/repositories/services/api/auth_apli_client.dart';
import '../../auth/presentation/view_models/auth_viewmodel.dart';
import '../../auth/presentation/view_models/logout_button_viewmodel.dart';
import '../../manual/data/manual_repository.dart';
import '../../manual/data/manual_repository_impl.dart';
import '../../manual/interactor/blocs/manual_bloc.dart';
import '../../menu/interactor/modules/menu_page_module.dart';
import '../data/message_rate_repository.dart';
import '../data/message_rate_repository_impl.dart';
import '../data/search_repository.dart';
import '../data/search_repository_impl.dart';
import '../data/vehicle_info_repository.dart';
import '../data/vehicle_info_repository_impl.dart';
import '../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../interactor/blocs/chatpage_inputs/chat_page_input_bloc.dart';
import '../interactor/blocs/message_rate/message_rate_bloc.dart';
import '../interactor/blocs/vehicle_form/vehicle_form_bloc.dart';
import '../ui/pages/chat_page.dart';

class ChatPageModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<ChatPageBloc>(ChatPageBloc.new);
    i.addLazySingleton<ChatPageInputBloc>(ChatPageInputBloc.new);
    i.addLazySingleton<LoadingOverlayBloc>(LoadingOverlayBloc.new);
    i.addLazySingleton<VehicleFormBloc>(VehicleFormBloc.new);
    i.add<LogoutButtonViewModel>(LogoutButtonViewModel.new);
    i.addLazySingleton<ManualBloc>(ManualBloc.new);
    i.add<AuthRepository>(AuthRepositoryImpl.new);
    i.add<AuthApiClient>(AuthApiClientImpl.new);
    i.add<ManualRepository>(ManualRepositoryImpl.new);
    i.add<VehicleInfoRepository>(VehicleInfoRepositoryImpl.new);
    i.add<SharedPreferencesRepository>(SharedPreferencesRepositoryImpl.new);
    i.add<SharedPreferencesService>(LanguagePreferencesServiceImpl.new);
    i.addSingleton<AuthViewModel>(AuthViewModel.new);
    i.add<SearchRepository>(SearchRepositoryImpl.new);
    i.add<http.Client>(http.Client.new);
    i.addSingleton<MessageRateBloc>(MessageRateBloc.new);
    i.add<MessageRateRepository>(MessageRateRepositoryImpl.new);
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
    r.module('/menu-page', module: MenuPageModule());
  }
}
