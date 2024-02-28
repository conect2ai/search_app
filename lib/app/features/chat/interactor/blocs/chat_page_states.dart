import '../../../../core/entities/chat_message.dart';

abstract class ChatPageState {}

class InitialChatPageState extends ChatPageState {
  String message;
  InitialChatPageState({required this.message});
}

class ReceiveResponseState extends ChatPageState {
  List<ChatMessage> results;

  ReceiveResponseState({required this.results});
}
