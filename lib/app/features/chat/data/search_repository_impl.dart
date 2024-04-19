import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../core/entities/auth_user.dart';
import '../../../services/secure_storage_service.dart';
import 'search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SecureStorageService _secureStorageService;
  final AuthUser _authUser;

  SearchRepositoryImpl(this._secureStorageService, this._authUser);

  final apiBaseUrl = dotenv.get('API_SEARCH_URL');
  final apiConvertAudioToTextEndpoint =
      dotenv.get('API_SEARCH_ENDPOINT_CONVERT_AUDIO_TO_TEXT');
  final apiQuestionEndpoint = dotenv.get('API_SEARCH_ENDPOINT_QUESTION');
  final apiQuestionWithImageEndpoint =
      dotenv.get('API_SEARCH_ENDPOINT_QUESTION_IMAGE');

  Future<String?> getApiKey() {
    return _secureStorageService.readSecureData(_authUser.username ?? '');
  }

  @override
  Future<String> sendQuestionByAudio(
      String audioFilePath, String imageFilePath) async {
    final audioFile =
        await http.MultipartFile.fromPath('audio_file', audioFilePath);

    final apiUri = Uri.http(apiBaseUrl, apiConvertAudioToTextEndpoint);

    final apiKey = await getApiKey();

    final Map<String, String> headers = {
      'accept': 'multipart/form-data',
      'Authorization': 'Bearer $apiKey',
    };

    final requestConversion = http.MultipartRequest('POST', apiUri)
      ..headers.addAll(headers)
      ..files.add(audioFile);

    final questionStreamedResponse = await requestConversion.send().timeout(
      const Duration(seconds: 120),
      onTimeout: () {
        throw const HttpException("Failed to communicate with server");
      },
    );
    final questionString =
        await questionStreamedResponse.stream.bytesToString();

    final questionJson = jsonDecode(questionString) as Map<String, dynamic>;
    final question = questionJson['text'] as String;

    return question;
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
      'brand': 'Volkswagen',
      'model': 'Polo',
      'year': '2023',
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
      final responseData = jsonDecode(response.body);
      return responseData['response_content'];
    } else {
      final responseErrorJson = jsonDecode(response.body);
      throw HttpException(responseErrorJson['detail']['msg']);
    }
  }

  @override
  Future<String> sendQuestionByTextWithImage(
      String question, String imageFilePath) async {
    final imageFile =
        await http.MultipartFile.fromPath('image_file', imageFilePath);

    final apiKey = await getApiKey();
    final apiUri = Uri.http(apiBaseUrl, apiQuestionWithImageEndpoint);

    final Map<String, String> headers = {
      'accept': 'multipart/form-data',
      'Authorization': 'Bearer $apiKey',
    };

    final fields = {
      'question': question,
      'brand': 'Volkswagen',
      'model': 'Polo',
      'year': '2023',
    };

    final request = http.MultipartRequest('POST', apiUri)
      ..files.add(imageFile)
      ..fields.addAll(fields)
      ..headers.addAll(headers);

    final response = await request.send().timeout(
      const Duration(seconds: 120),
      onTimeout: () {
        throw const HttpException("Failed to communicate with server");
      },
    );

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      final responseData = jsonDecode(data);
      return responseData['response_content'];
    } else {
      final error = await response.stream.bytesToString();
      final responseError = jsonDecode(error);
      throw HttpException(responseError['detail']['msg']);
    }
  }
}
