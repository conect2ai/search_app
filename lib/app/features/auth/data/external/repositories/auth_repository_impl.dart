import '../../../domain/infra/repositories/services/api/auth_apli_client.dart';
import '../../auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient _authApiClient;

  AuthRepositoryImpl(this._authApiClient);

  @override
  Future<void> checkIfTokenIsValid() {
    return _authApiClient.checkIfTokenIsValid();
  }

  @override
  Future<void> login(Map<String, String> loginData) {
    return _authApiClient.login(loginData);
  }

  @override
  Future<void> logout() {
    return _authApiClient.logout();
  }

  @override
  Future<void> recoverPassword(String email) {
    return _authApiClient.recoverPassword(email);
  }

  @override
  Future<void> signUp(String signUpData) {
    return _authApiClient.signUp(signUpData);
  }
}
