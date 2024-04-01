import 'package:image_picker/image_picker.dart';

abstract class ChatPageEvent {}

class LoadChatPageEvent extends ChatPageEvent {}

class PickImageEvent extends ChatPageEvent {}

class SendTextEvent extends ChatPageEvent {
  String question;
  SendTextEvent({required this.question});
}

class SendAudioEvent extends ChatPageEvent {
  String path;
  SendAudioEvent({required this.path});
}

class SelectImageEvent extends ChatPageEvent {
  XFile file;

  SelectImageEvent({required this.file});
}

class RemoveImageEvent extends ChatPageEvent {}
