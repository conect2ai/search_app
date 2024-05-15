import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../core/entities/auth_user.dart';
import '../../../mixins/secure_storage.dart';
import 'upload_manual_repository.dart';

class UploadManualRepositoryImpl
    with SecureStorage
    implements UploadManualRepository {
  final AuthUser _authUser;

  UploadManualRepositoryImpl(this._authUser);

  final apiBaseUrl = dotenv.get('API_SEARCH_URL');
  final processPdfEndpoint = dotenv.get('PROCESS_PDF_ENDPOINT');

  Future<String?> getApiKey() {
    return readSecureData(_authUser.username ?? '');
  }

  @override
  void uploadManualPdf(String pdfFileName, String pdfFilePath) async {
    final apiUri = Uri.http(
      apiBaseUrl,
      processPdfEndpoint,
    );

    final apiKey = await getApiKey();

    final pdf = await http.MultipartFile.fromPath(
      'pdfs',
      pdfFilePath,
      filename: pdfFileName,
    );

    final Map<String, String> headers = {
      'accept': 'multipart/form-data',
      'Authorization': 'Bearer $apiKey',
    };

    final requestConversion = http.MultipartRequest('POST', apiUri)
      ..headers.addAll(headers)
      ..files.add(pdf);

    final response = await requestConversion.send().timeout(
      const Duration(seconds: 120),
      onTimeout: () {
        throw const HttpException("Failed to communicate with server");
      },
    );

    if (response.statusCode == 200) {
      final data = await http.Response.fromStream(response);
      final responseData = jsonDecode(utf8.decode(data.bodyBytes));
      print(responseData);
    } else if (response.statusCode == 422) {
      final error = await response.stream.bytesToString();
      final responseError = jsonDecode(error);
      throw HttpException(responseError['detail'][0]['msg']);
    } else {
      throw const HttpException('An error occurred!');
    }
  }
}
