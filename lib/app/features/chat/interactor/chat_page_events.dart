abstract class ChatPageEvent {}

class LoadChatPageEvent extends ChatPageEvent {}

class PickImageEvent extends ChatPageEvent {}

class SendTextEvent extends ChatPageEvent {
  String response = "Sua resposta";
}

class SendAudioEvent extends ChatPageEvent {}
