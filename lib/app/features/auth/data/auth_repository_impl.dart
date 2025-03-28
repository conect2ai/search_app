import 'dart:convert';
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

import '../../../core/entities/auth_user.dart';
import '../../../mixins/http_client_mixin.dart';
import '../../../mixins/secure_storage.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl
    with SecureStorage, CustomHttpClientMixin
    implements AuthRepository {
  final AuthUser _user;
  final _baseAuthUrl = FlutterConfig.get('API_AUTH_URL');
  final _baseValidateKeyUrl = FlutterConfig.get('API_SEARCH_URL');
  final _verifyKeyValidEnpoint =
      FlutterConfig.get('CHECK_IF_VALID_API_KEY_ENDPOINT');
  final _saveKeyEnpoint = FlutterConfig.get('SAVE_API_KEY_ENDPOINT');
  final _tokenValidationEndpoint =
      FlutterConfig.get('TOKEN_VALIDATION_ENDPOINT');
  final _loginEndpoint = FlutterConfig.get('LOGIN_ENDPOINT');
  final _signUpEndpoint = FlutterConfig.get('SIGN_UP_ENDPOINT');
  final _recoverPasswordEndpoint =
      FlutterConfig.get('RECOVER_PASSWORD_ENDPOINT');

  AuthRepositoryImpl(this._user);

  Future<String?> getApiKey() async {
    return readSecureData(_user.username ?? '');
  }

  @override
  Future<void> checkIfTokenIsValid() async {
    final token = _user.token;
    final client = await configureHttpClient();
    final validateTokenUri =
        Uri.https(_baseAuthUrl, _tokenValidationEndpoint, {'token': token});

    final Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await client.get(
      validateTokenUri,
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw const HttpException('Invalid token.');
    }
  }

  @override
  Future<String?> checkIfUserHasKey() async {
    final client = await configureHttpClient();
    final validateKeyUri =
        Uri.https(_baseValidateKeyUrl, _verifyKeyValidEnpoint);

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
      throw const HttpException('Não foi possível validar chave da API');
    }
  }

  @override
  Future<void> recoverPassword(String email) async {
    final client = await configureHttpClient();
    final response =
        await client.post(Uri.https(_baseAuthUrl, _recoverPasswordEndpoint),
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': email,
            }));

    if (response.statusCode != 200) {
      throw const HttpException('Erro ao enviar o email. Tente novamente');
    }
  }

  @override
  Future<bool> validateKey(String apiKey) async {
    final client = await configureHttpClient();
    final validateKeyUri = Uri.https(_baseValidateKeyUrl, _saveKeyEnpoint);

    // final apiKey = await getApiKey();

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
          'key': apiKey,
        },
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['valid']) {
        _user.updateApiKey(data['openai_key']);
        writeSecureData(_user.username!, data['openai_key']);
      }
      return data['valid'];
    } else {
      throw const HttpException('Não foi possível validar chave da API');
    }
  }

  @override
  Future<void> login(Map<String, String> loginData) async {
    final client = await configureHttpClient();
    final loginUrl = Uri.https(_baseAuthUrl, _loginEndpoint);
    final loginInfo = {
      'username': loginData['username'],
      'password': loginData['password'],
    };

    final response = await client.post(loginUrl,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: loginInfo);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _user.updateToken(data);
      _user.updatedUsernameAndPassword(loginInfo);
      writeSecureData('username', loginData['username']);
      writeSecureData('password', loginData['password']);
      writeSecureData('access_token', _user.token);
      writeSecureData('token_type', _user.tokenType);
    } else {
      throw const HttpException('Login failed. Try again.');
    }
  }

  @override
  Future<void> signUp(String signUpData) async {
    final client = await configureHttpClient();
    final signUpUrl = Uri.https(_baseAuthUrl, _signUpEndpoint);
    final response = await client.post(signUpUrl,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': signUpData,
        }));

    if (response.statusCode != 200) {
      throw const HttpException('Erro ao enviar o email. Tente novamente');
    }
  }

  @override
  Future<void> logout() async {
    _user.updateToken({'access_token': null, 'token_type': null});
    deleteSecureData('access_token');
    deleteSecureData('token_type');
  }
}
