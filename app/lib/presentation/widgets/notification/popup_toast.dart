import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class AppToast {
  // Gunakan BuildContext agar FToast bisa membaca tema dan merender widget kustom
  static void _showCustomToast(BuildContext context, String message, Color bgColor) {
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: bgColor,
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 14.0),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  static void showError(BuildContext context, String message) {
    _showCustomToast(context, message, Colors.red);
  }

  static void showSuccess(BuildContext context, String message) {
    _showCustomToast(context, message, Colors.green);
  }

  static void showUndo(BuildContext context) {
    _showCustomToast(context, "Input dibatalkan", Colors.orange);
  }
}