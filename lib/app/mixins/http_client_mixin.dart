import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

mixin CustomHttpClientMixin {
  Future<SecurityContext> get globalContext async {
    final certDashboard = await rootBundle
        .load('assets/certs/dashboard.conect2ai.dca.ufrn.br.crt');
    final certChatbot =
        await rootBundle.load('assets/certs/chatbot.conect2ai.dca.ufrn.br.crt');
    final keyDashboard = await rootBundle
        .load('assets/certs/dashboard.conect2ai.dca.ufrn.br.key');
    final keyChatbot =
        await rootBundle.load('assets/certs/chatbot.conect2ai.dca.ufrn.br.key');
    final securityContext = SecurityContext();
    securityContext
        .setTrustedCertificatesBytes(certDashboard.buffer.asUint8List());
    securityContext
        .setTrustedCertificatesBytes(certChatbot.buffer.asUint8List());
    securityContext.usePrivateKeyBytes(keyDashboard.buffer.asUint8List());
    securityContext.usePrivateKeyBytes(keyChatbot.buffer.asUint8List());
    return securityContext;
  }

  Future<http.Client> configureHttpClient() async {
    HttpClient client = HttpClient(context: await globalContext);

    IOClient ioClient = IOClient(client);

    return ioClient;
  }
}
