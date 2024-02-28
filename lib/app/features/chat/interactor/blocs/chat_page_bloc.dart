import 'package:bloc/bloc.dart';

import '../../../../core/entities/chat_message.dart';
import '../../data/infra/search_repository.dart';
import 'chat_page_event.dart';
import 'chat_page_states.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  final SearchRepository searchRepository;
  final List<ChatMessage> _results = [];

  ChatPageBloc({required this.searchRepository})
      : super(InitialChatPageState(message: "Envie sua pergunta")) {
    on<SendTextEvent>(
      (event, emit) {
        _results.add(ChatMessage(message: event.question, isQuestion: true));
        _results.add(ChatMessage(
            message: searchRepository.getResponse(event.question),
            isQuestion: false));
        emit(
          ReceiveResponseState(results: _results),
        );
      },
    );
  }
}
