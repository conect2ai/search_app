import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

import '../../../app_module.dart';
import '../data/search_repository.dart';
import '../data/search_repository_impl.dart';
import '../interactor/blocs/chatpage/chat_page_bloc.dart';
import '../interactor/blocs/chatpage_inputs/chat_page_input_bloc.dart';
import '../ui/chat_page.dart';

class ChatPageModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<ChatPageBloc>(ChatPageBloc.new);
    i.add<ChatPageInputBloc>(ChatPageInputBloc.new);
    i.add<SearchRepository>(SearchRepositoryImpl.new);
    i.add<http.Client>(http.Client.new);
  }

  @override
  List<Module> get imports => [
        AppModule(),
      ];

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const ChatPage(),
    );
  }
}
