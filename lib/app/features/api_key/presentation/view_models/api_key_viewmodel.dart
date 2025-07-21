import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../exceptions/api_key_not_found_exception.dart';
import '../../../../exceptions/invalid_api_key_exception.dart';
import '../../../../exceptions/server_communication_exception.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../domain/infra/repositories/api_key_repository.dart';

class ApiKeyViewModel extends ChangeNotifier {
  final ApiKeyRepository _apiKeyRepository;
  final AuthRepository _authRepository;
  final _user = Modular.get<AuthUser>();

  ApiKeyViewModel({
    required ApiKeyRepository apiKeyRepository,
    required AuthRepository authRepository,
  })  : _apiKeyRepository = apiKeyRepository,
        _authRepository = authRepository;

  Future<void> checkApiKey(String provider) async {
    try {
      final apiKey = await _apiKeyRepository.checkIfUserHasKey(provider);

      if (apiKey == null || apiKey.isEmpty) {
        throw ApiKeyNotFoundException();
      }
      _user.updateApiKey(apiKey);
    } on ApiKeyNotFoundException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  String? getApiKey() {
    return _user.apiKey;
  }

  Future<void> validateApiKey(String apiKey) async {
    final key = _user.username;
    if (key != null) {
      if (_user.token != null) {
        try {
          return await _apiKeyRepository.validateKey(apiKey);
        } on InvalidApiKeyException catch (_) {
          rethrow;
        } on ServerCommunicationException catch (_) {
          rethrow;
        } catch (e) {
          rethrow;
        }
      }
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    Modular.to.navigate('/');
  }
}
