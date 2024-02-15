abstract class ChatPageState {}

class InitialChatPageState extends ChatPageState {
  String message;

  InitialChatPageState({required this.message});
}

class ReceiveResponseState extends ChatPageState {
  String response;

  ReceiveResponseState({required this.response});
}
