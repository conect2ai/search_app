import 'dart:io';

abstract class ChatPageEvent {}

class LoadChatPageEvent extends ChatPageEvent {}

class PickImageEvent extends ChatPageEvent {}

class SendTextEvent extends ChatPageEvent {
  String question;
  File? picture;
  SendTextEvent({required this.question, this.picture});
}

class SendAudioEvent extends ChatPageEvent {
  String path;
  SendAudioEvent({required this.path});
}

// class SelectImageEvent extends ChatPageEvent {
//   XFile file;

//   SelectImageEvent({required this.file});
// }

// class RemoveImageEvent extends ChatPageEvent {}
