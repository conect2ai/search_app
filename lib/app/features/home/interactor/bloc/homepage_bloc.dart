import 'package:bloc/bloc.dart';

import '../../../../core/entities/auth_user.dart';
import '../../../../mixins/secure_storage.dart';
import '../events/homepage_events.dart';
import '../states/homepage_states.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState>
    with SecureStorage {
  HomePageBloc(this._user) : super(InputApiKeyState());

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
      return await readSecureData(key);
    }
    return null;
  }

  void saveApiKey(String apiKey) async {
    final key = _user.username;
    if (key != null) {
      writeSecureData(key, apiKey);
    }
  }
}
