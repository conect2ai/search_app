import 'search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  @override
  String getResponse(String question) {
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
