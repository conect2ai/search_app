import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import '../../../core/entities/auth_user.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Client client;
  final AuthUser _user = AuthUser();
  final baseAuthUrl = dotenv.env['API_AUTH_URL'];

  AuthRepositoryImpl({required this.client});

  @override
  Future<bool> login(Map<String, String> loginData) async {
    try {
      final loginUrl = Uri.parse('$baseAuthUrl/token');
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
    final signUpUrl = Uri.parse('$baseAuthUrl/register');
    final signUpInfo = json.encode({
      'username': signUpData['username'],
      'email': signUpData['email'],
      'password': signUpData['password'],
      'role': signUpData['role'],
    });

    try {
      final response = await client.post(signUpUrl,
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
    _user.updateToken({'access_token': null, 'token_type': null});
    print('Logout');
  }
}
