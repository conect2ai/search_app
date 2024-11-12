import 'package:rxdart/rxdart.dart';

class LoginBloc {
  BehaviorSubject<bool>? _isTryingLoginSubject;
  Stream<bool>? get isTryingLogin => _isTryingLoginSubject?.stream;

  void initSubjects() {
    _isTryingLoginSubject = BehaviorSubject<bool>();
  }

  void updateLoginButton(bool islogin) {
    _isTryingLoginSubject?.sink.add(islogin);
  }

  void dispose() {
    _isTryingLoginSubject?.close();
    _isTryingLoginSubject = null;
  }
}
