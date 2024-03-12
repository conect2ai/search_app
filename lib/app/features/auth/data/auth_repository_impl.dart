import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Client client;
  final baseAuthUrl = dotenv.env['API_AUTH_URL'];

  AuthRepositoryImpl({required this.client});

  @override
  Future<String?> Login(Map<String, String> loginData) async {
    return "Logado";
  }

  @override
  Future<void> SignUp(Map<String, String> signUpData) async {
    final signUpUrl = Uri.parse('$baseAuthUrl/register');
    final data = json.encode({
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
          body: data);
      if (response.statusCode == 201) {
        print(response.body);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }
}
