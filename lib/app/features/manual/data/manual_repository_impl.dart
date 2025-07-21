import 'dart:convert';
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';

import '../../../mixins/http_client_mixin.dart';
import '../../../mixins/secure_storage.dart';
import '../../auth/domain/entities/auth_user.dart';
import 'manual_repository.dart';

class ManualRepositoryImpl
    with SecureStorage, CustomHttpClientMixin
    implements ManualRepository {
  final AuthUser _authUser;

  ManualRepositoryImpl(this._authUser);

  final apiBaseUrl = FlutterConfig.get('API_SEARCH_URL');
  final processPdfEndpoint = FlutterConfig.get('PROCESS_PDF_ENDPOINT');
  final manualCheckEndpoint = FlutterConfig.get('API_CARS_ENDPOINT');

  @override
  Future<bool> uploadManualPdf(String pdfFileName, String pdfFilePath) async {
    final client = await configureHttpClient();
    final apiUri = Uri.https(
      apiBaseUrl,
      processPdfEndpoint,
    );

    final pdf = File(pdfFilePath);
    final pdfBytes = await pdf.readAsBytes();
    final pdfBase64 = base64Encode(pdfBytes);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_authUser.token}',
    };

    final data = [
      {'filename': pdfFileName, 'content': pdfBase64}
    ];

    final response =
        await client.post(apiUri, body: jsonEncode(data), headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 422) {
      throw const HttpException('Falha no upload. Tente novamente');
    } else {
      throw const HttpException('Ocorreu um erro!');
    }
  }

  @override
  Future<bool> checkIfThereIsManual() async {
    final client = await configureHttpClient();
    final apiUri = Uri.https(
      apiBaseUrl,
      manualCheckEndpoint,
    );

    final Map<String, String> headers = {
      'accept': 'multipart/form-data',
      'Authorization': 'Bearer ${_authUser.token}',
    };

    final response = await client.get(apiUri, headers: headers);

    if (response.statusCode == 200) {
      final data = response.body;
      return data.isNotEmpty;
    } else if (response.statusCode == 422) {
      throw const HttpException('Falha ao checar manuais disponíveis');
    } else {
      throw const HttpException('Ocorreu um erro!');
    }
  }
}
