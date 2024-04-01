class AuthUser {
  String? _token;
  String? _tokenType;
  String? _username;
  String? _password;

  static final AuthUser _authUser = AuthUser._internal();

  factory AuthUser() {
    return _authUser;
  }

  AuthUser._internal();

  String? get token => _token;
  String? get tokenType => _tokenType;
  String? get username => _username;
  String? get password => _password;

  void updatedUsernameAndPassword(Map<String, String?> userInfo) {
    _username = userInfo['username'];
    _password = userInfo['password'];
  }

  void updateToken(Map<String, dynamic> tokenInfo) {
    _token = tokenInfo['access_token'];
    _tokenType = tokenInfo['token_type'];
  }
}
