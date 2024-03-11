abstract interface class AuthRepository {
  Future<String?> Login(Map<String, String> loginData);
  Future<String?> SignUp(Map<String, String> signUpData);
}
