import 'package:flutter/material.dart';

class CustomAlertDilog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required Function() onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            content,
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Mark as Read", style: TextStyle(color: Colors.black)),
              onPressed: () {
                onConfirm(); // Call the provided callback
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
