import 'package:image_picker/image_picker.dart';

import '../../../../../core/entities/chat_message.dart';

abstract class ChatPageState {}

class InitialChatPageState extends ChatPageState {}

class ReceiveResponseState extends ChatPageState {
  List<ChatMessage> results;

  ReceiveResponseState({required this.results});
}

class ImageSelectedState extends ChatPageState {
  XFile file;

  ImageSelectedState({required this.file});
}
