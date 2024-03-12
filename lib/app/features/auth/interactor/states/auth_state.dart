abstract class AuthState {}

class LoginState extends AuthState {
  String? username;
  String? password;
  LoginState({
    this.username,
    this.password,
  });
}

class SignUpState extends AuthState {
  String? username;
  String? password;
  SignUpState({
    this.username,
    this.password,
  });
}
