abstract interface class SearchRepository {
  Future<String> sendQuestionByText(
    String question,
  );
  Future<String> sendQuestionByTextWithImage(
      String question, String imageFilePath);
  Future<String> sendQuestionByAudio(
    String audioFilePath,
  );
}
