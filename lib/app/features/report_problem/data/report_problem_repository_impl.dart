import 'dart:convert';
import 'dart:io';

import 'package:flutter_config/flutter_config.dart';

import '../../../mixins/http_client_mixin.dart';
import '../../auth/domain/entities/auth_user.dart';
import 'report_problem_repository.dart';

class ReportProblemRepositoryImpl
    with CustomHttpClientMixin
    implements ReportProblemRepository {
  final _apiBaseUrl = FlutterConfig.get('API_SEARCH_URL');
  final _audioTranscriptionEndpoint =
      FlutterConfig.get('AUDIO_REPORT_TRANSCRIPTION_ENDPOINT');
  final AuthUser _authUser;

  ReportProblemRepositoryImpl(this._authUser);

  @override
  Future<Map> sendAudioReportForTranscription(String audioFilePath) async {
    final client = await configureHttpClient();
    final audioFile = File(audioFilePath);
    final audioBytes = await audioFile.readAsBytes();
    final audioBase64 = base64Encode(audioBytes);

    final data = {'audio_file': audioBase64};

    final apiUri = Uri.https(_apiBaseUrl, _audioTranscriptionEndpoint);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_authUser.token}',
    };

    final response = await client
        .post(apiUri, body: jsonEncode(data), headers: headers)
        .timeout(const Duration(seconds: 120));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData;
    } else {
      throw const HttpException(
          'Failed to communicate with server. Try again.');
    }
  }
}
