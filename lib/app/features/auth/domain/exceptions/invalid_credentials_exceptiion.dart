class InvalidCredentialsException implements Exception {
  final String message;

  InvalidCredentialsException(this.message);

  @override
  String toString() {
    return message;
  }
}
