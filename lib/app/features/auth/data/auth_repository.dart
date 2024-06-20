abstract interface class AuthRepository {
  Future<void> login(Map<String, String> loginData);
  Future<void> signUp(String signUpData);
  Future<void> validateKey();
  Future<void> checkIfKeyIsValid();
  Future<void> checkIfTokenIsValid();
  Future<void> logout();
}
