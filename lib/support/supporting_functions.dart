import 'package:flutter/material.dart';

bool isValidEmail(String email) {
  return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
}

bool isValidPasswordLength(String password) {
  return password.length >= 9;
}

bool isValidPasswordFormat(String password) {
  // Check for at least one uppercase letter
  bool hasUppercase = password.contains(RegExp(r'[A-Z]'));

  // Check for at least one digit
  bool hasDigits =
      password.contains(RegExp(r'\d')); // \d is shorthand for [0-9]

  // Check for at least one symbol
  bool hasSymbols = password.contains(RegExp(
      r'[\W_]')); // \W is shorthand for non-word characters, _ is included as it's not covered by \W in Dart

  return hasUppercase && hasDigits && hasSymbols;
}

void showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
