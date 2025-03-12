import 'package:flutter/material.dart';

class SnackbarService {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackbar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double fontSize = 14.0,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: fontSize, color: textColor),
      ),
      duration: duration,
      action: action,
      backgroundColor: backgroundColor,
    );

    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  static void showSuccessSnackbar(String message) {
    showSnackbar(
      message: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  static void showErrorSnackbar(String message) {
    showSnackbar(
      message: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  static void showInfoSnackbar(String message) {
    showSnackbar(
      message: message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  static void showWarningSnackbar(String message) {
    showSnackbar(
      message: message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }
}
