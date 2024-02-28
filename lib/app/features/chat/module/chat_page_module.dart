import 'package:flutter_modular/flutter_modular.dart';

import '../data/infra/search_repository.dart';
import '../data/infra/search_repository_impl.dart';
import '../interactor/chat_page_bloc.dart';
import '../ui/chat_page.dart';

class ChatPageModule extends Module {
  @override
  void binds(i) {
    i.add<ChatPageBloc>(ChatPageBloc.new);
    i.add<SearchRepository>(SearchRepositoryImpl.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const ChatPage(),
    );
  }
}
