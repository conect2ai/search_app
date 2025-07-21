abstract interface class AuthApiClient {
  Future<void> login(Map<String, String> loginData);
  Future<void> signUp(String signUpData);
  Future<void> checkIfTokenIsValid();
  Future<void> recoverPassword(String email);
  Future<void> logout();
}
