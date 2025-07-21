abstract class SharedPreferencesService {
  Future<bool> save(dynamic);
  Future<String?> getInfo(String key);
}
