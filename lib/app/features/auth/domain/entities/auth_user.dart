class AuthUser {
  String? _token;
  String? _tokenType;
  String? _username;
  String? _apiKey;

  static final AuthUser _authUser = AuthUser._internal();

  factory AuthUser() {
    return _authUser;
  }

  AuthUser._internal();

  String? get token => _token;
  String? get tokenType => _tokenType;
  String? get username => _username;
  String? get apiKey => _apiKey;

  void updatedUsernameAndPassword(Map<String, String?> userInfo) {
    _username = userInfo['username'];
  }

  void updateToken(Map<String, dynamic> tokenInfo) {
    _token = tokenInfo['access_token'];
    _tokenType = tokenInfo['token_type'];
  }

  void updateApiKey(String? apiKeyInfo) {
    _apiKey = apiKeyInfo;
  }
}
