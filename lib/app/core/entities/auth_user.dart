class AuthUser {
  String? _token;
  String? _tokenType;

  static final AuthUser _authUser = AuthUser._internal();

  factory AuthUser() {
    return _authUser;
  }

  AuthUser._internal();

  String? get token => _token;
  void updateToken(Map<String, dynamic> tokenInfo) {
    _token = tokenInfo['access_token'];
    _tokenType = tokenInfo['token_type'];
  }
}
