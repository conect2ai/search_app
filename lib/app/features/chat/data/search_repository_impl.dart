import 'package:http/http.dart';

import 'search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final Client client;

  SearchRepositoryImpl({required this.client});

  @override
  Future<String> getResponse(String question) async {
    switch (question) {
      case 'Oi':
        return 'Oi, tudo bem?';
      case 'Tudo bem':
        return 'Que bom que está bem';
      case 'Adeus':
        return 'Até a próxima';
      default:
        return 'Não entendi sua pergunta';
    }
  }
}
