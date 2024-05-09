abstract class ChatPageInputEvent {}

class FocusTextEvent extends ChatPageInputEvent {}

class FocusAudioEvent extends ChatPageInputEvent {}

class StartLoadingEvent extends ChatPageInputEvent {
  // String? question;
  // String? imagePath;
  // String? audioPath;

  // SendQuestionEvent(this.question, this.audioPath, this.imagePath);
}

class FinishLoadingEvent extends ChatPageInputEvent {}
