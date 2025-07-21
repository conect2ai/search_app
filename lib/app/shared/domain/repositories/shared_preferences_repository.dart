abstract interface class SharedPreferencesRepository {
  Future<bool> save(dynamic data);
  Future<String?> getInfo(String key);
}
