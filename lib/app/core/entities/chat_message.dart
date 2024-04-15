class ChatMessage {
  final String? message;
  final String? audioPath;
  final String? imagePath;
  final bool isAudio;
  final bool isQuestion;

  ChatMessage(
      {this.message,
      required this.isQuestion,
      required this.isAudio,
      this.audioPath,
      this.imagePath});
}
