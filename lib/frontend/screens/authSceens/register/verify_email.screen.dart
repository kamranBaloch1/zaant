
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
 

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please verify your email',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              height: 20.h,
            ),
            ElevatedButton(
              onPressed: () async {
             
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
