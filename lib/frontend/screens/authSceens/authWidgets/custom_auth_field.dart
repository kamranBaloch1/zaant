// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAuthTextField extends StatelessWidget {
  final String hintText;
  final Widget? icon;
  final bool obSecure;
  final TextInputType keyBoardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomAuthTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.obSecure,
    required this.keyBoardType,
    required this.controller,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: obSecure,
        keyboardType: keyBoardType,
         validator: validator,
        controller: controller,
        style: TextStyle(fontSize: 16.sp,color:Colors.black),
        decoration: InputDecoration(
         hintText: hintText,
          prefixIcon: icon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
 
 
  }
}
