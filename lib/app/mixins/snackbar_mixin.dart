import 'package:flutter/material.dart';

mixin SnackBarMixin {
  void generateSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message), duration: const Duration(milliseconds: 1200)));
  }
}
