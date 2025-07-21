import 'package:app_search/app/shared/domain/services/shared_preferences_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../app_module.dart';
import '../../../shared/data/repositories/shared_preferences_repository_impl.dart';
import '../../../shared/data/services/language_preferences_service_impl.dart';
import '../../../shared/domain/repositories/shared_preferences_repository.dart';
import '../../api_key/modules/load_api_key_module.dart';
import '../data/auth_repository.dart';
import '../data/external/repositories/auth_repository_impl.dart';
import '../data/external/services/api/auth_api_client_impl.dart';
import '../domain/infra/repositories/services/api/auth_apli_client.dart';
import '../presentation/ui/auth_screen.dart';
import '../presentation/ui/login_screen.dart';
import '../presentation/ui/recover_password_screen.dart';
import '../presentation/ui/sign_up_screen.dart';
import '../presentation/view_models/auth_viewmodel.dart';
import '../presentation/view_models/login_viewmodel.dart';
import '../presentation/view_models/recover_password_viewmodel.dart';
import '../presentation/view_models/signup_viewmodel.dart';

class AuthModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<SignUpViewModel>(SignUpViewModel.new);
    i.addSingleton<LoginViewModel>(LoginViewModel.new);
    i.add<AuthApiClient>(AuthApiClientImpl.new);
    i.add<AuthRepository>(AuthRepositoryImpl.new);
    i.add<SharedPreferencesRepository>(SharedPreferencesRepositoryImpl.new);
    i.add<SharedPreferencesService>(LanguagePreferencesServiceImpl.new);
    i.addSingleton<AuthViewModel>(AuthViewModel.new);
    i.addSingleton<RecoverPasswordViewModel>(RecoverPasswordViewModel.new);
  }

  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void routes(r) {
    r.child('/', child: (context) => const AuthScreen());
    r.child('/sign-up', child: (context) => const SignUpScreen());
    r.child('/login', child: (context) => const LoginScreen());
    r.child('/recover-password',
        child: (context) => const RecoverPasswordScreen());
  }
}
