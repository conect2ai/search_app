import 'package:bloc/bloc.dart';

import '../../../../core/entities/auth_user.dart';
import '../../../../services/secure_storage_service.dart';
import '../events/homepage_events.dart';
import '../states/homepage_states.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc(this._secureStorageService, this._user)
      : super(InputApiKeyState());

  final SecureStorageService _secureStorageService;
  final AuthUser _user;

  bool validateApiKey(String apiKey) {
    if (apiKey.isEmpty || apiKey == '') {
      return false;
    } else {
      return true;
    }
  }

  Future<String?> readSavedApiKey() async {
    final key = _user.username;
    if (key != null) {
      return await _secureStorageService.readSecureData(key);
    }
    return null;
  }

  void saveApiKey(String apiKey) async {
    final key = _user.username;
    if (key != null) {
      _secureStorageService.writeSecureData(key, apiKey);
    }
  }
}
