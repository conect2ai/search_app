abstract interface class AuthRepository {
  Future<void> login(Map<String, String> loginData);
  Future<void> signUp(String signUpData);
  Future<void> checkIfTokenIsValid();
  Future<void> recoverPassword(String email);
  Future<void> logout();
}
