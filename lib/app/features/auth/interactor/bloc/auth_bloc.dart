import 'package:bloc/bloc.dart';

import '../../../../core/entities/auth_user.dart';
import '../../data/auth_repository.dart';
import '../events/auth_event.dart';
import '../states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthUser userAuth = AuthUser();
  AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(LoginState()) {
    on<SwitchToLoginEvent>((event, emit) =>
        emit(LoginState(username: event.username, password: event.password)));
    on<SwitchToSignUpEvent>((event, emit) =>
        emit(SignUpState(username: event.username, password: event.password)));
  }

  Future<bool> login(Map<String, String> formData) async {
    final result = await authRepository.login(formData);
    return result; //mudar quando implementar os status code
  }

  Future<bool> signUp(Map<String, String> formData) async {
    final result = await authRepository.signUp(formData);
    return result; //mudar quando implementar os status code
  }

  void logout() async {
    authRepository.logout();
  }
}
