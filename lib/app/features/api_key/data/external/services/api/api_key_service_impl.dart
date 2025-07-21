import 'dart:convert';

import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../../exceptions/invalid_api_key_exception.dart';
import '../../../../../../exceptions/api_key_not_found_exception.dart';
import '../../../../../../exceptions/server_communication_exception.dart';
import '../../../../../../mixins/http_client_mixin.dart';
import '../../../../../../mixins/secure_storage.dart';
import '../../../../../auth/domain/entities/auth_user.dart';
import '../../../../domain/infra/services/api/api_key_service.dart';

class ApiKeyServiceImpl
    with SecureStorage, CustomHttpClientMixin
    implements ApiKeyService {
  final _user = Modular.get<AuthUser>();

  final _baseValidateKeyUrl = FlutterConfig.get('API_SEARCH_URL');
  final _verifyKeyValidEnpoint =
      FlutterConfig.get('CHECK_IF_VALID_API_KEY_ENDPOINT');
  final _saveKeyEnpoint = FlutterConfig.get('SAVE_API_KEY_ENDPOINT');

  @override
  Future<String?> checkIfUserHasKey(String provider) async {
    final client = await configureHttpClient();
    final validateKeyUri =
        Uri.https(_baseValidateKeyUrl, _verifyKeyValidEnpoint)
            .replace(queryParameters: {
      'provider': provider.toLowerCase(),
    });

    final Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_user.token}',
    };
    final response = await client.get(
      validateKeyUri,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['key'];
    } else {
      throw ApiKeyNotFoundException();
    }
  }

  @override
  Future<void> validateKey(String apiKey) async {
    final client = await configureHttpClient();
    final validateKeyUri = Uri.https(_baseValidateKeyUrl, _saveKeyEnpoint);

    final Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_user.token}',
    };
    final response = await client.post(
      validateKeyUri,
      headers: headers,
      body: jsonEncode(
        {
          'provider': 'openai',
          'key': apiKey,
        },
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['valid']) {
        _user.updateApiKey(data['key']);
        writeSecureData(_user.username!, data['key']);
      }
      if (!data['valid']) {
        throw InvalidApiKeyException();
      }
    } else {
      throw ServerCommunicationException();
    }
  }
}
