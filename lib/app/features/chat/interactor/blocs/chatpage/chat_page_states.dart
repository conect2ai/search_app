import '../../../../../core/entities/chat_message.dart';

abstract class ChatPageState {}

class InitialChatPageState extends ChatPageState {}

class ReceiveResponseState extends ChatPageState {
  List<ChatMessage> results;

  ReceiveResponseState({required this.results});
}
