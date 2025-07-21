abstract interface class ApiKeyService {
  Future<String?> checkIfUserHasKey(String provider);
  Future<void> validateKey(String apiKey);
}
