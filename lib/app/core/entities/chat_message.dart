class ChatMessage {
  final String? id;
  final String? message;
  final String? audioPath;
  final String? imagePath;
  final bool isAudio;
  final bool isQuestion;

  ChatMessage(
      {this.message,
      this.id,
      required this.isQuestion,
      required this.isAudio,
      this.audioPath,
      this.imagePath});
}
