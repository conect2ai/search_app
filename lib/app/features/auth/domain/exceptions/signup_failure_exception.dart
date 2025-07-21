class SignUpFailureException implements Exception {
  final String message;

  SignUpFailureException(this.message);

  @override
  String toString() {
    return message;
  }
}
