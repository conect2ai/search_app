import 'package:bloc/bloc.dart';

import '../events/homepage_events.dart';
import '../states/homepage_states.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(InputApiKeyState());

  bool validateApiKey(String apiKey) {
    if (apiKey.isEmpty || apiKey == '') {
      return false;
    } else {
      return true;
    }
  }
}
