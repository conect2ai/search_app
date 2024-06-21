import 'dart:io';

import '../../../data/message_rate_repository.dart';

class MessageRateBloc {
  final MessageRateRepository _messageRateRepository;

  MessageRateBloc(this._messageRateRepository);

  Future<void> sendLike(Map<String, String?> messageRateData) async {
    try {
      await _messageRateRepository.sendLike(messageRateData);
    } on HttpException catch (_) {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> sendDislike(Map<String, String?> messageRateData) async {
    try {
      await _messageRateRepository.sendDislike(messageRateData);
    } on HttpException catch (_) {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}
