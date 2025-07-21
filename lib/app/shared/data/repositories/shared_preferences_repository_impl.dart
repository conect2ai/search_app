import '../../domain/repositories/shared_preferences_repository.dart';
import '../../domain/services/shared_preferences_service.dart';

class SharedPreferencesRepositoryImpl implements SharedPreferencesRepository {
  final SharedPreferencesService _preferencesService;

  SharedPreferencesRepositoryImpl(this._preferencesService);
  @override
  Future<String?> getInfo(String key) {
    return _preferencesService.getInfo(key);
  }

  @override
  Future<bool> save(data) {
    return _preferencesService.save(data);
  }
}
