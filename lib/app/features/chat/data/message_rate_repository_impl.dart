import 'dart:convert';
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';

import '../../../core/entities/auth_user.dart';
import 'message_rate_repository.dart';
import 'package:http/http.dart' as http;

class MessageRateRepositoryImpl implements MessageRateRepository {
  final _baseUrl = FlutterConfig.get('API_RATE_MESSAGE_URL');
  final _likeEndpoint = FlutterConfig.get('LIKE_MESSAGE_ENDPOINT');
  final _dislikeEndpoint = FlutterConfig.get('DISLIKE_MESSAGE_ENDPOINT');
  final AuthUser _user;

  MessageRateRepositoryImpl(this._user);

  @override
  Future<void> sendDislike(Map<String, String?> messageRateData) async {
    final sendDislikeUri = Uri.http(_baseUrl, _dislikeEndpoint);

    final dislikeData = {
      {
        'message_id': messageRateData['messageId'],
        'assistant_message': messageRateData['responseMessage'],
        'user_message': messageRateData['userMessage'],
        'feedback': messageRateData['feedback'],
        'additional_info': messageRateData['additionalInfo']
      }
    };
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_user.token}',
    };

    final response = await http.post(sendDislikeUri,
        headers: headers, body: jsonEncode(dislikeData));

    if (response.statusCode != 200) {
      throw const HttpException('Failed to rate message');
    }
  }

  @override
  Future<void> sendLike(Map<String, String?> messageRateData) async {
    final sendLikeUri = Uri.http(_baseUrl, _likeEndpoint);

    final likeData = {
      {
        'message_id': messageRateData['messageId'],
        'assistant_message': messageRateData['responseMessage'],
        'user_message': messageRateData['userMessage'],
        'feedback': messageRateData['feedback'],
        'additional_info': messageRateData['additionalInfo']
      }
    };

    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_user.token}',
    };

    final response = await http.post(sendLikeUri,
        headers: headers, body: jsonEncode(likeData));

    if (response.statusCode != 200) {
      throw const HttpException('Failed to rate message');
    }
  }
}
