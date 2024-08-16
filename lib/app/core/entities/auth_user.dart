class AuthUser {
  String? _token;
  String? _tokenType;
  String? _username;
  String? _password;
  String? _apiKey;

  static final AuthUser _authUser = AuthUser._internal();

  factory AuthUser() {
    return _authUser;
  }

  AuthUser._internal();

  String? get token => _token;
  String? get tokenType => _tokenType;
  String? get username => _username;
  String? get password => _password;
  String? get apiKey => _apiKey;

  void updatedUsernameAndPassword(Map<String, String?> userInfo) {
    _username = userInfo['username'];
    _password = userInfo['password'];
  }

  void updateToken(Map<String, dynamic> tokenInfo) {
    _token = tokenInfo['access_token'];
    _tokenType = tokenInfo['token_type'];
  }

  void updateApiKey(String? apiKeyInfo) {
    _apiKey = apiKeyInfo;
  }
}
