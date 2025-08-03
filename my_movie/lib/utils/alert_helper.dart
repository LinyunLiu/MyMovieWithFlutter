import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class AlertHelper {
  static void showTopFlushbar(BuildContext context, String message) {
    Flushbar(
      messageText: Text(
        message,
        style: TextStyle(
          color: Color(0xFFFAEBD7),
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: 'Roboto'
        )
      ),
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      maxWidth: 400,
    ).show(context);
  }
}