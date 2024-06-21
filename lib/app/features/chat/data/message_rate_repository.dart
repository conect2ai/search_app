abstract interface class MessageRateRepository {
  Future<void> sendLike(Map<String, String?> messageRateData);
  Future<void> sendDislike(Map<String, String?> messageRateData);
}
