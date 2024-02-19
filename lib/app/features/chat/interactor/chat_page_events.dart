abstract class ChatPageEvent {}

class LoadChatPageEvent extends ChatPageEvent {}

class PickImageEvent extends ChatPageEvent {}

class SendTextEvent extends ChatPageEvent {
  String question;
  SendTextEvent({required this.question});
}

class SendAudioEvent extends ChatPageEvent {}
