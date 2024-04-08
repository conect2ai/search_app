abstract interface class SearchRepository {
  Future<String> sendQuestionByText(String question, String imageFilePath);
  Future<String> sendQuestionByAudio(
      String audioFilePath, String imageFilePath);
}
