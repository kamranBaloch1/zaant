import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaanth/global/colors.dart';
import 'package:zaanth/global/constant_values.dart';

class StartLoadingBar extends StatelessWidget {
  const StartLoadingBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: scaffoldBgColor ,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // image goes here
            Image.asset(
               assetLogoImg,
                        width: 220.w,
                         height: 180.h,
            ),
            SizedBox(height: 5.h), 
            // Circular loading bar
          const  CircularProgressIndicator(color:  Color.fromARGB(255, 35, 49, 129),),
          ],
        ),
      ),
    );
  }
}
