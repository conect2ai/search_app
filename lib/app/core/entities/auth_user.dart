class AuthUser {
  String? _token;

  String? get token => _token;
  void UpdateToken(String token) {
    _token = token;
  }
}
