import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/authSceens/authWidgets/custom_auth_field.dart';
import 'package:zant/frontend/screens/authSceens/login/forgot_password.dart';
import 'package:zant/frontend/screens/authSceens/register/register_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/global/constant_values.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();

  bool _isObscure = true;
  // bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    _emailC.dispose();
    _passwordC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: scaffoldBgColor,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 40.h,
                    ),
                    Center(
                      child: Image.asset(
                assetLogoImg,
                width: 250.w,
                height: 180.h,
              ),
                    ),
                    SizedBox(
                      height: 80.h,
                    ),
                    CustomAuthTextField(
                      hintText: "Email",
                      icon: const Icon(Icons.email),
                      obSecure: false,
                      keyBoardType: TextInputType.emailAddress,
                      controller: _emailC,
                      validator: (value) {
                        return RegExp(
                                    // Regular expression to validate email
                                    r"[a-z0-9!#%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(value!)
                            ? null
                            : "Please enter a valid email address";
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomAuthTextField(
                      hintText: "Password",
                      icon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                      obSecure: _isObscure,
                      keyBoardType: TextInputType.text,
                      controller: _passwordC,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 8) {
                          return 'Password must be more than 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const RegisterScreen());
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 15.w, top: 15.h),
                        alignment: Alignment.bottomRight,
                        child: const Text(
                          "Register?",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Center(
                      child: CustomButton(
                        navigateToNextScreen: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                        width: 200,
                        height: 40,
                        text: "Login",
                        bgColor: Colors.blue,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ForgotPasswordScreen());
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 15.w, top: 100.h),
                        alignment: Alignment.center,
                        child: const Text(
                          "Forgotten Password?",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
