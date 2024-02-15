import 'package:flutter_modular/flutter_modular.dart';

import '../interactor/chat_page_bloc.dart';
import '../ui/chat_page.dart';

class ChatPageModule extends Module {
  @override
  void binds(i) {
    i.add<ChatPageBloc>(ChatPageBloc.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => ChatPage(),
    );
  }
}
