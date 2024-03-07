import 'package:bloc/bloc.dart';

import '../../../../../core/entities/chat_message.dart';
import '../../../data/search_repository.dart';
import 'chat_page_event.dart';
import 'chat_page_states.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  final SearchRepository searchRepository;
  final List<ChatMessage> _results = [];

  ChatPageBloc({required this.searchRepository})
      : super(InitialChatPageState(message: "Envie sua pergunta")) {
    on<SendTextEvent>(
      (event, emit) async {
        _results.add(ChatMessage(
            message: event.question, isQuestion: true, isAudio: false));
        _results.add(ChatMessage(
            message: await searchRepository.getResponse(event.question),
            isQuestion: false,
            isAudio: false));

        emit(ReceiveResponseState(results: _results));
      },
    );
    on<SendAudioEvent>(
      (event, emit) {
        _results.add(ChatMessage(
            audioPath: event.path, isQuestion: true, isAudio: true));
        emit(ReceiveResponseState(results: _results));
      },
    );
  }
}