import 'dart:convert';
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';

import '../../../core/entities/auth_user.dart';
import '../../../core/entities/car_info.dart';
import '../../../mixins/http_client_mixin.dart';
import '../../../mixins/secure_storage.dart';
import 'search_repository.dart';

class SearchRepositoryImpl
    with SecureStorage, CustomHttpClientMixin
    implements SearchRepository {
  final AuthUser _authUser;
  final CarInfo _carInfo;

  SearchRepositoryImpl(this._authUser, this._carInfo);

  final apiBaseUrl = FlutterConfig.get('API_SEARCH_URL');
  final apiQuestionWithAudio =
      FlutterConfig.get('API_SEARCH_ENDPOINT_QUESTION_AUDIO');
  final apiQuestionEndpoint = FlutterConfig.get('API_SEARCH_ENDPOINT_QUESTION');
  final apiQuestionWithImageEndpoint =
      FlutterConfig.get('API_SEARCH_ENDPOINT_QUESTION_IMAGE');

  @override
  Future<Map<dynamic, dynamic>> sendQuestionByAudio(
      String audioFilePath) async {
    final client = await configureHttpClient();
    final audioFile = File(audioFilePath);
    final audioBytes = await audioFile.readAsBytes();
    final audioBase64 = base64Encode(audioBytes);

    final data = {
      'brand': _carInfo.brand,
      'model': _carInfo.model,
      'year': _carInfo.year,
      'audio_file': audioBase64
    };

    final apiUri = Uri.https(apiBaseUrl, apiQuestionWithAudio);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_authUser.token}',
    };

    final response =
        await client.post(apiUri, body: jsonEncode(data), headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData;
    } else {
      throw const HttpException(
          'Falha ao processar resposta. Tente novamente.');
    }
  }

  @override
  Future<Map<dynamic, dynamic>> sendQuestionByText(String question) async {
    final client = await configureHttpClient();
    final apiUri = Uri.https(apiBaseUrl, apiQuestionEndpoint);

    final Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_authUser.token}',
    };

    final fields = {
      'question': question,
      'brand': _carInfo.brand,
      'model': _carInfo.model,
      'year': _carInfo.year,
    };

    final response = await client
        .post(apiUri, body: jsonEncode(fields), headers: headers)
        .timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        throw const HttpException(
            'Falha ao se comunicar com servidor. Tente novamente.');
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData;
    } else {
      throw const HttpException(
          'Falha ao processar resposta. Tente novamente.');
    }
  }

  @override
  Future<Map<dynamic, dynamic>> sendQuestionByTextWithImage(
      String question, String imageFilePath) async {
    final client = await configureHttpClient();
    final image = File(imageFilePath);

    final imageBytes = await image.readAsBytes();
    final imageBase64 = base64Encode(imageBytes);

    final apiUri = Uri.https(apiBaseUrl, apiQuestionWithImageEndpoint);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_authUser.token}',
    };

    final data = {
      'image_file': imageBase64,
      'question': question,
    };

    final response =
        await client.post(apiUri, body: jsonEncode(data), headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData;
    } else {
      throw const HttpException(
          'Falha ao processar resposta. Tente novamente.');
    }
  }
}
