import 'dart:convert';
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';

import '../../../core/entities/auth_user.dart';
import '../../../mixins/http_client_mixin.dart';
import 'message_rate_repository.dart';

class MessageRateRepositoryImpl
    with CustomHttpClientMixin
    implements MessageRateRepository {
  final _baseUrl = FlutterConfig.get('API_RATE_MESSAGE_URL');
  final _likeEndpoint = FlutterConfig.get('LIKE_MESSAGE_ENDPOINT');
  final _dislikeEndpoint = FlutterConfig.get('DISLIKE_MESSAGE_ENDPOINT');
  final AuthUser _user;

  MessageRateRepositoryImpl(this._user);

  @override
  Future<void> sendDislike(Map<String, String?> messageRateData) async {
    final client = await configureHttpClient();
    final sendDislikeUri = Uri.https(_baseUrl, _dislikeEndpoint);

    final dislikeData = {
      'response_id': messageRateData['response_id'],
      'additional_info': messageRateData['additional_info']
    };
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_user.token}',
    };

    final response = await client.post(sendDislikeUri,
        headers: headers, body: jsonEncode(dislikeData));

    if (response.statusCode != 200) {
      throw const HttpException('Failed to rate message');
    }
  }

  @override
  Future<void> sendLike(Map<String, String?> messageRateData) async {
    final client = await configureHttpClient();
    final sendLikeUri = Uri.https(_baseUrl, _likeEndpoint);

    final likeData = {
      'response_id': messageRateData['response_id'],
      'additional_info': messageRateData['additional_info']
    };

    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_user.token}',
    };

    final response = await client.post(sendLikeUri,
        headers: headers, body: jsonEncode(likeData));

    if (response.statusCode != 200) {
      throw const HttpException('Failed to rate message');
    }
  }
}
