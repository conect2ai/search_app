import 'package:flutter_modular/flutter_modular.dart';

import '../../ui/check_api_key_screen.dart';

class CheckApiKeyModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const CheckApiKeyScreen(),
    );
  }
}
