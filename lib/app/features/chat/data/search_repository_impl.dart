import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../core/entities/auth_user.dart';
import '../../../core/entities/car_info.dart';
import '../../../mixins/secure_storage.dart';
import 'search_repository.dart';

class SearchRepositoryImpl with SecureStorage implements SearchRepository {
  final AuthUser _authUser;
  final CarInfo _carInfo;

  SearchRepositoryImpl(this._authUser, this._carInfo);

  final apiBaseUrl = dotenv.get('API_SEARCH_URL');
  final apiQuestionWithAudio = dotenv.get('API_SEARCH_ENDPOINT_QUESTION_AUDIO');
  final apiQuestionEndpoint = dotenv.get('API_SEARCH_ENDPOINT_QUESTION');
  final apiQuestionWithImageEndpoint =
      dotenv.get('API_SEARCH_ENDPOINT_QUESTION_IMAGE');

  Future<String?> getApiKey() {
    return readSecureData(_authUser.username ?? '');
  }

  @override
  Future<String> sendQuestionByAudio(String audioFilePath) async {
    final audioFile =
        await http.MultipartFile.fromPath('audio_file', audioFilePath);

    final queryParams = {
      'brand': _carInfo.brand,
      'model': _carInfo.model,
      'year': _carInfo.year
    };

    final apiUri = Uri.http(apiBaseUrl, apiQuestionWithAudio, queryParams);

    final apiKey = await getApiKey();

    final Map<String, String> headers = {
      'accept': 'multipart/form-data',
      'Authorization': 'Bearer $apiKey',
    };

    final requestConversion = http.MultipartRequest('POST', apiUri)
      ..headers.addAll(headers)
      ..files.add(audioFile);

    final response = await requestConversion.send().timeout(
      const Duration(seconds: 120),
      onTimeout: () {
        throw const HttpException("Failed to communicate with server");
      },
    );

    if (response.statusCode == 200) {
      final data = await http.Response.fromStream(response);
      final responseData = jsonDecode(utf8.decode(data.bodyBytes));
      return responseData['response_content'];
    } else if (response.statusCode == 422) {
      final error = await response.stream.bytesToString();
      final responseError = jsonDecode(error);
      throw HttpException(responseError['detail']['msg']);
    } else {
      throw const HttpException('An error occurred!');
    }
  }

  @override
  Future<String> sendQuestionByText(String question) async {
    final apiKey = await getApiKey();
    final apiUri = Uri.http(apiBaseUrl, apiQuestionEndpoint);

    final Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final fields = {
      'question': question,
      'brand': _carInfo.brand,
      'model': _carInfo.model,
      'year': _carInfo.year,
    };

    final response = await http
        .post(apiUri, body: jsonEncode(fields), headers: headers)
        .timeout(
      const Duration(seconds: 120),
      onTimeout: () {
        throw Exception("Failed to communicate with server");
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData['response_content'];
    } else if (response.statusCode == 422) {
      final responseErrorJson = jsonDecode(utf8.decode(response.bodyBytes));
      throw HttpException(responseErrorJson['detail']['msg']);
    } else {
      throw const HttpException('An error occurred!');
    }
  }

  @override
  Future<String> sendQuestionByTextWithImage(
      String question, String imageFilePath) async {
    final imageFile =
        await http.MultipartFile.fromPath('image_file', imageFilePath);

    final apiKey = await getApiKey();
    final apiUri = Uri.http(apiBaseUrl, apiQuestionWithImageEndpoint, {
      'question': question,
    });

    final Map<String, String> headers = {
      'accept': 'multipart/form-data',
      'Authorization': 'Bearer $apiKey',
    };

    final fields = {
      'question': question,
      'brand': _carInfo.brand,
      'model': _carInfo.model,
      'year': _carInfo.year,
    };

    final request = http.MultipartRequest(
      'POST',
      apiUri,
    )
      ..files.add(imageFile)
      // ..fields.addAll(fields)
      ..headers.addAll(headers);

    final response = await request.send().timeout(
      const Duration(seconds: 120),
      onTimeout: () {
        throw const HttpException("Failed to communicate with server");
      },
    );

    if (response.statusCode == 200) {
      final data = await http.Response.fromStream(response);
      final responseData = jsonDecode(utf8.decode(data.bodyBytes));
      return responseData['choices'][0]['message']['content'];
    } else if (response.statusCode == 422) {
      final error = await response.stream.bytesToString();
      final responseError = jsonDecode(error);
      throw HttpException(responseError['detail']['msg']);
    } else {
      throw const HttpException('An error occurred!');
    }
  }
}
