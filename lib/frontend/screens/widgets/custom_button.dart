// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
 final double width;
 final double height;
 final String text;
final Color bgColor;
final void Function()? navigateToNextScreen;
  const CustomButton({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    required this.bgColor,
    this.navigateToNextScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateToNextScreen,
      child: Container(
        alignment: Alignment.center,
        height: height.h,
        width: width.w,
        child:  Text(text,style:  TextStyle(
          color: Colors.white,
          fontSize: 15.sp
        ),),
        decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.r)
        )
      ),
    );
  }
}
