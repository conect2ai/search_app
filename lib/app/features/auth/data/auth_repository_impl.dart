import 'dart:convert';
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

import '../../../core/entities/auth_user.dart';
import '../../../mixins/secure_storage.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl with SecureStorage implements AuthRepository {
  final AuthUser _user;
  final _baseAuthUrl = FlutterConfig.get('API_AUTH_URL');
  final _baseValidateKeyUrl = FlutterConfig.get('API_SEARCH_URL');
  final _verifyKeyValidEnpoint =
      FlutterConfig.get('CHECK_IF_VALID_API_KEY_ENDPOINT');
  final _saveKeyEnpoint = FlutterConfig.get('SAVE_API_KEY_ENDPOINT');

  AuthRepositoryImpl(this._user);

  Future<String?> getApiKey() async {
    return readSecureData(_user.username ?? '');
  }

  @override
  Future<void> checkIfKeyIsValid() async {
    final validateKeyUri =
        Uri.http(_baseValidateKeyUrl, _verifyKeyValidEnpoint);

    final apiKey = await getApiKey();

    final Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_user.token}',
    };
    final response = await http.get(
      validateKeyUri,
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw const HttpException('Não foi possível validar a chave.');
    }
  }

  @override
  Future<void> validateKey() async {
    final validateKeyUri = Uri.http(_baseValidateKeyUrl, _saveKeyEnpoint);

    final apiKey = await getApiKey();

    final Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_user.token}',
    };
    final response = await http.post(
      validateKeyUri,
      headers: headers,
      body: jsonEncode(
        {
          'key': apiKey,
        },
      ),
    );

    if (response.statusCode != 200) {
      throw const HttpException('Não foi possível validar a chave.');
    }
  }

  @override
  Future<bool> login(Map<String, String> loginData) async {
    try {
      final loginUrl = Uri.http(_baseAuthUrl, '/account/user/login');
      final loginInfo = {
        'username': loginData['username'],
        'password': loginData['password'],
      };

      final response = await http.post(loginUrl,
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signUp(Map<String, String> signUpData) async {
    final signUpUrl = Uri.http(_baseAuthUrl, '/register');
    final signUpInfo = json.encode({
      'username': signUpData['username'],
      'email': signUpData['email'],
      'password': signUpData['password'],
      'role': signUpData['role'],
    });

    try {
      final response = await http.post(signUpUrl,
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
          body: signUpInfo);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void logout() async {
    _user.updateToken({'access_token': null, 'token_type': null});
    deleteSecureData('access_token');
    deleteSecureData('token_type');
  }
}
