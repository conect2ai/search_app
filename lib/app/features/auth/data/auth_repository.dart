abstract interface class AuthRepository {
  Future<bool> login(Map<String, String> loginData);
  Future<bool> signUp(Map<String, String> signUpData);
  Future<void> validateKey(String apiKey);
  void logout();
}
