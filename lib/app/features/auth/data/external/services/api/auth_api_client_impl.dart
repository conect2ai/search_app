import 'dart:convert';
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';

import '../../../../../../mixins/http_client_mixin.dart';
import '../../../../../../mixins/secure_storage.dart';
import '../../../../domain/entities/auth_user.dart';
import '../../../../domain/exceptions/invalid_credentials_exceptiion.dart';
import '../../../../domain/exceptions/signup_failure_exception.dart';
import '../../../../domain/infra/repositories/services/api/auth_apli_client.dart';
import '../../../exceptions/server_exception.dart';

class AuthApiClientImpl
    with SecureStorage, CustomHttpClientMixin
    implements AuthApiClient {
  final AuthUser _user;
  final _baseAuthUrl = FlutterConfig.get('API_AUTH_URL');
  final _tokenValidationEndpoint =
      FlutterConfig.get('TOKEN_VALIDATION_ENDPOINT');
  final _loginEndpoint = FlutterConfig.get('LOGIN_ENDPOINT');
  final _signUpEndpoint = FlutterConfig.get('SIGN_UP_ENDPOINT');
  final _recoverPasswordEndpoint =
      FlutterConfig.get('RECOVER_PASSWORD_ENDPOINT');

  AuthApiClientImpl(this._user);

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
      // writeSecureData('username', loginData['username']);
      // writeSecureData('password', loginData['password']);
      // writeSecureData('access_token', _user.token);
      // writeSecureData('token_type', _user.tokenType);
    } else if (response.statusCode == 401) {
      throw InvalidCredentialsException('Login failed. Try again.');
    } else {
      throw ServerException(
          'Could not connect to the server. Please try again later.');
    }
  }

  @override
  Future<void> signUp(String signUpData) async {
    final client = await configureHttpClient();
    final signUpUrl = Uri.https(_baseAuthUrl, _signUpEndpoint);
    try {
      final response = await client.post(signUpUrl,
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': signUpData,
          }));

      if (response.statusCode != 200) {
        throw SignUpFailureException('_');
      }
    } on SignUpFailureException catch (_) {
      rethrow;
    } catch (e) {
      throw ServerException('_');
    }
  }

  @override
  Future<void> logout() async {
    _user.updateToken({'access_token': null, 'token_type': null});
    deleteSecureData('access_token');
    deleteSecureData('token_type');
  }
}
