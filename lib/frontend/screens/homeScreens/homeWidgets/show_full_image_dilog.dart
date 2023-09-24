import 'package:flutter/material.dart';

class FullImageDialog extends StatelessWidget {
  final String imageUrl;

  FullImageDialog({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height, // Adjust the height as needed
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the dialog when tapped
          },
          child: Container(), // Empty container to capture gestures
        ),
      ),
    );
  }
}
