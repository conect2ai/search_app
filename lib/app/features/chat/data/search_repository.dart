abstract interface class SearchRepository {
  Future<Map<dynamic, dynamic>> sendQuestionByText(
    String question,
  );
  Future<Map<dynamic, dynamic>> sendQuestionByTextWithImage(
      String question, String imageFilePath);
  Future<Map<dynamic, dynamic>> sendQuestionByAudio(
    String audioFilePath,
  );
  Future<Map<dynamic, dynamic>> sendAudioForTranscription(
    String audioFilePath,
  );
}
