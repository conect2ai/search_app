abstract interface class SearchRepository {
  Future<String> getResponse(String question);
}
