import 'package:bloc/bloc.dart';

import '../../../../core/entities/auth_user.dart';
import '../../data/auth_repository.dart';
import '../events/auth_event.dart';
import '../states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthUser userAuth = AuthUser();
  AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(LoginState()) {
    on<SwitchToLoginEvent>((event, emit) => emit(LoginState()));
    on<SwitchToSignUpEvent>((event, emit) => emit(SignUpState()));
  }

  Future<bool> Login(Map<String, String> formData) async {
    print('Email = ${formData['email']}');
    print('Password = ${formData['password']}');
    final String? token = await authRepository.Login(formData);
    if (token != null) {
      userAuth.UpdateToken(token);
      return true;
    }
    return false;
  }

  Future<bool> SignUp(Map<String, String> formData) async {
    print('Email = ${formData['email']}');
    print('Password = ${formData['password']}');
    print('Username = ${formData['username']}');
    final String? token = await authRepository.SignUp(formData);
    if (token != null) {
      userAuth.UpdateToken(token);
      return true;
    }
    return false;
  }
}
