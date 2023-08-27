
import 'package:flutter/material.dart';

class CustomLoadingOverlay extends StatelessWidget {
  const CustomLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return    Container(
          color: Colors.black.withOpacity(0.6),
          child: const Center(
            child:  CircularProgressIndicator(),
          ),
        );
  }
}