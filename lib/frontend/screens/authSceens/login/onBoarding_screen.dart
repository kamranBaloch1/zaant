import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/authSceens/login/login_screen.dart';
import 'package:zant/frontend/screens/authSceens/register/register_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/global/constant_values.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              Image.asset(
                assetLogoImg,
                width: 250.w,
                height: 180.h,
              ),
              SizedBox(height: 100.h),
              CustomButton(
                bgColor: Colors.blue,
                height: 40,
                width: 300,
                text: "Login",
                onTap: () {
                  Get.to(() => const LoginScreen());
                },
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 2.w,
                    height: 40.h,
                    color: Colors.black26,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "or",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Container(
                    width: 2.w,
                    height: 40.h,
                    color: Colors.black26,
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              CustomButton(
                bgColor: Colors.blue,
                height: 40,
                width: 300,
                text: "Signup",
                onTap: () {
                  Get.to(() => const RegisterScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
