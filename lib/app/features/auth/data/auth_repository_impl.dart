import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../core/entities/auth_user.dart';
import '../../../mixins/secure_storage.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl with SecureStorage implements AuthRepository {
  final AuthUser user;
  final baseAuthUrl = dotenv.get('API_AUTH_URL');
  final baseValidateKeyUrl = dotenv.get('API_SEARCH_URL');

  AuthRepositoryImpl({required this.user});

  Future<String?> getApiKey() async {
    return readSecureData(user.username ?? '');
  }

  @override
  Future<void> validateKey(String apiKey) async {
    final validateKeyUri = Uri.http(baseValidateKeyUrl, '/chat/validate');

    final apiKey = await getApiKey();

    final Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${user.token}',
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

    print(response.statusCode);
    if (response.statusCode != 200) {
      throw const HttpException('Não foi possível validar a chave.');
    }
  }

  @override
  Future<bool> login(Map<String, String> loginData) async {
    try {
      final loginUrl = Uri.http(baseAuthUrl, '/account/user/login');
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
        user.updateToken(data);
        user.updatedUsernameAndPassword(loginInfo);
        writeSecureData('username', loginData['username']);
        writeSecureData('password', loginData['password']);
        writeSecureData('access_token', user.token);
        writeSecureData('token_type', user.tokenType);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> signUp(Map<String, String> signUpData) async {
    final signUpUrl = Uri.http(baseAuthUrl!, '/register');
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
      print(e);
      return false;
    }
  }

  @override
  void logout() async {
    user.updateToken({'access_token': null, 'token_type': null});
    deleteSecureData('access_token');
    deleteSecureData('token_type');
  }
}
