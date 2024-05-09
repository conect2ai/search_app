abstract class AuthEvent {}

class SwitchToLoginEvent extends AuthEvent {
  String? username;
  String? password;
  SwitchToLoginEvent({
    this.username,
    this.password,
  });
}

class SwitchToSignUpEvent extends AuthEvent {
  String? username;
  String? password;
  SwitchToSignUpEvent({
    this.username,
    this.password,
  });
}
