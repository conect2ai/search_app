import 'dart:convert';
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

import '../../../core/entities/auth_user.dart';
import '../../../mixins/secure_storage.dart';
import 'upload_manual_repository.dart';

class UploadManualRepositoryImpl
    with SecureStorage
    implements UploadManualRepository {
  final AuthUser _authUser;

  UploadManualRepositoryImpl(this._authUser);

  final apiBaseUrl = FlutterConfig.get('API_SEARCH_URL');
  final processPdfEndpoint = FlutterConfig.get('PROCESS_PDF_ENDPOINT');

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
    print(response.statusCode);
    if (response.statusCode == 200) {
      // final data = await http.Response.fromStream(response);
      // final responseData = jsonDecode(utf8.decode(data.bodyBytes));
      return true;
    } else if (response.statusCode == 422) {
      throw const HttpException('Manual upload failed. Try again later');
    } else {
      throw const HttpException('An error occurred!');
    }
  }
}
