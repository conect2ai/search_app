import 'package:bloc/bloc.dart';

import '../events/auth_event.dart';
import '../states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoginState()) {
    on<SwitchToLoginEvent>((event, emit) => emit(LoginState()));
    on<SwitchToSignUpEvent>((event, emit) => emit(SignUpState()));
  }

  void Login(Map<String, String> formData) {
    print('Email = ${formData['email']}');
    print('Password = ${formData['password']}');
    print('Logou');
  }

  void SignUp(Map<String, String> formData) {
    print('Email = ${formData['email']}');
    print('Password = ${formData['password']}');
    print('Registrou');
  }
}