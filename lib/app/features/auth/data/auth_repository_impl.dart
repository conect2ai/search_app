import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String?> Login(Map<String, String> loginData) async {
    return "Logado";
  }

  @override
  Future<String?> SignUp(Map<String, String> signUpData) async {
    return "Registrado";
  }
}
