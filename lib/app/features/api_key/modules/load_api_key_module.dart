import 'package:flutter_modular/flutter_modular.dart';

import '../../../app_module.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/external/repositories/auth_repository_impl.dart';
import '../../auth/data/external/services/api/auth_api_client_impl.dart';
import '../../auth/domain/entities/auth_user.dart';
import '../../auth/domain/infra/repositories/services/api/auth_apli_client.dart';
import '../data/external/repositories/api_key_repository/api_key_repository_impl.dart';
import '../data/external/services/api/api_key_service_impl.dart';
import '../domain/infra/repositories/api_key_repository.dart';
import '../domain/infra/services/api/api_key_service.dart';
import '../presentation/ui/api_key_input.dart';
import '../presentation/ui/confirm_api_key_screen.dart';
import '../presentation/ui/load_api_key_screen.dart';
import '../presentation/view_models/api_key_viewmodel.dart';

class ApiKeyModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<AuthUser>(AuthUser.new);
    i.addSingleton<ApiKeyViewModel>(ApiKeyViewModel.new);
    i.add<ApiKeyService>(ApiKeyServiceImpl.new);
    i.add<ApiKeyRepository>(ApiKeyRepositoryImpl.new);
    i.add<AuthApiClient>(AuthApiClientImpl.new);
    i.add<AuthRepository>(AuthRepositoryImpl.new);
  }

  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void routes(r) {
    r.child('/',
        child: (context) => LoadApiKeyScreen(
            provider: r.args.queryParams['provider'] ?? 'openai'));
    r.child('/input_api_key',
        child: (context) =>
            ApiKeyInput(provider: r.args.queryParams['provider'] ?? 'openai'));
    r.child('/confirm_api_key',
        child: (context) => ConfirmApiKeyScreen(
            provider: r.args.queryParams['provider'] ?? 'openai'));
  }
}
