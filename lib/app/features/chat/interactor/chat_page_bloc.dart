import 'package:bloc/bloc.dart';

import 'chat_page_events.dart';
import 'chat_page_states.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  ChatPageBloc() : super(InitialChatPageState(message: "Envie sua pergunta")) {
    on<SendTextEvent>(
      (event, emit) => emit(
        ReceiveResponseState(response: event.response),
      ),
    );
  }
}
