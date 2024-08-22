import 'package:flutter_modular/flutter_modular.dart';

import '../../../chat/module/chat_page_module.dart';
import '../../ui/manual_check_screen.dart';

class ManualCheckModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const ManualCheckPage(),
    );
    r.module(
      '/chat',
      module: ChatPageModule(),
    );
  }
}
