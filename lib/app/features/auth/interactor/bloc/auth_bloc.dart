import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

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

  Future<void> login(Map<String, String> formData) async {
    await authRepository.login(formData);
  }

  Future<void> signUp(String formData) async {
    await authRepository.signUp(formData);
  }

  Future<void> logout() async {
    await authRepository.logout();
    Modular.to.navigate('/');
  }
}
