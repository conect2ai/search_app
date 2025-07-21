abstract interface class ApiKeyRepository {
  Future<String?> checkIfUserHasKey(String provider);
  Future<void> validateKey(String apiKey);
}
