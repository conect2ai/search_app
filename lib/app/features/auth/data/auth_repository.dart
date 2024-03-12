abstract interface class AuthRepository {
  Future<String?> Login(Map<String, String> loginData);
  Future<void> SignUp(Map<String, String> signUpData);
}
