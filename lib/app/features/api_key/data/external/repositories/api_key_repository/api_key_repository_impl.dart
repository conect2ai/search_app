import '../../../../domain/infra/repositories/api_key_repository.dart';
import '../../../../domain/infra/services/api/api_key_service.dart';

class ApiKeyRepositoryImpl implements ApiKeyRepository {
  final ApiKeyService _apiKeyService;
  ApiKeyRepositoryImpl(this._apiKeyService);

  @override
  Future<String?> checkIfUserHasKey(String provider) async {
    return await _apiKeyService.checkIfUserHasKey(provider);
  }

  @override
  Future<void> validateKey(String apiKey, String provider) async {
    await _apiKeyService.validateKey(apiKey, provider);
  }
}
