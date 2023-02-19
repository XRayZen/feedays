import 'package:feedays/main.dart';
import 'package:flutter/material.dart';

void showSnack(BuildContext context, int duration, String message) {
  scaffoldMessengerKey.currentState!.showSnackBar(
    SnackBar(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      duration: Duration(milliseconds: duration),
      content: Text(
        '{$message}',
        style: TextStyle(
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    ),
  );
}
