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
  final apiEndPoints = dotenv.get('API_SEARCH_ENDPOINTS');

  Future<String?> getApiKey() {
    return _secureStorageService.readSecureData(_authUser.username ?? '');
  }

  @override
  Future<String> sendQuestionByAudio(
      String audioFilePath, String imageFilePath) async {
    final imageFile = await http.MultipartFile.fromPath('image', imageFilePath);
    final audioFile = await http.MultipartFile.fromPath('audio', audioFilePath);

    final apiUri = Uri.https(apiBaseUrl, '/chat/chat');

    final apiKey = await getApiKey();

    final request = http.MultipartRequest('POST', apiUri)
      ..fields['api_key'] = apiKey ?? ''
      ..files.add(imageFile)
      ..files.add(audioFile);

    final response = await request.send();

    print(response);

    if (response.statusCode == 201) {
      print(response.stream.first);
      return '';
    } else {
      throw HttpException('No response');
    }
  }

  @override
  Future<String> sendQuestionByText(
      String question, String imageFilePath) async {
    final imageFile = await http.MultipartFile.fromPath('image', imageFilePath);

    final apiKey = await getApiKey();
    final apiUri = Uri.https(
        apiBaseUrl, apiEndPoints, {'api_key': apiKey, 'question': question});

    final request = http.MultipartRequest('POST', apiUri)..files.add(imageFile);

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      print(responseData);
      return responseData;
    } else {
      final responseError = await response.stream.bytesToString();
      final responseErrorJson = jsonDecode(responseError);
      throw HttpException(responseErrorJson['detail']['msg']);
    }
  }
}
