import 'dart:io';

import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

import '../../../core/entities/auth_user.dart';
import '../../../mixins/secure_storage.dart';
import 'manual_repository.dart';

class ManualRepositoryImpl with SecureStorage implements ManualRepository {
  final AuthUser _authUser;

  ManualRepositoryImpl(this._authUser);

  final apiBaseUrl = FlutterConfig.get('API_SEARCH_URL');
  final processPdfEndpoint = FlutterConfig.get('PROCESS_PDF_ENDPOINT');
  final manualCheckEndpoint = FlutterConfig.get('API_CARS_ENDPOINT');

  @override
  Future<bool> uploadManualPdf(String pdfFileName, String pdfFilePath) async {
    final apiUri = Uri.http(
      apiBaseUrl,
      processPdfEndpoint,
    );

    final pdf = await http.MultipartFile.fromPath(
      'pdfs',
      pdfFilePath,
      filename: pdfFileName,
    );

    final Map<String, String> headers = {
      'accept': 'multipart/form-data',
      'Authorization': 'Bearer ${_authUser.token}',
    };

    final requestConversion = http.MultipartRequest('POST', apiUri)
      ..headers.addAll(headers)
      ..files.add(pdf);

    final response = await requestConversion.send().timeout(
      const Duration(seconds: 120),
      onTimeout: () {
        throw const HttpException("Failed to communicate with server. Timeout");
      },
    );
    if (response.statusCode == 200) {
      // final data = await http.Response.fromStream(response);
      // final responseData = jsonDecode(utf8.decode(data.bodyBytes));
      return true;
    } else if (response.statusCode == 422) {
      throw const HttpException('Falha no upload. Tente novamente');
    } else {
      throw const HttpException('Ocorreu um erro!');
    }
  }

  @override
  Future<bool> checkIfThereIsManual() async {
    final apiUri = Uri.http(
      apiBaseUrl,
      manualCheckEndpoint,
    );

    final Map<String, String> headers = {
      'accept': 'multipart/form-data',
      'Authorization': 'Bearer ${_authUser.token}',
    };

    final response = await http.get(apiUri, headers: headers);

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
