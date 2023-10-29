
import 'package:flutter/material.dart';

class CustomScaffoaldLoader extends StatelessWidget {
  const CustomScaffoaldLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return   const Scaffold(
       body:    Center(
                child:  CircularProgressIndicator(),
              
            )
    );
  }
}