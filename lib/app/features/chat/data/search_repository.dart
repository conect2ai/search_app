import 'dart:io';

abstract interface class SearchRepository {
  Future<String> getResponse(String question, File? imageFile);
}
