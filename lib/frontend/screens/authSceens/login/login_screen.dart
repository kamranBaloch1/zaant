import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/auth/login_providers.dart';
import 'package:zant/frontend/screens/authSceens/authWidgets/custom_auth_field.dart';
import 'package:zant/frontend/screens/authSceens/login/forgot_password.dart';
import 'package:zant/frontend/screens/authSceens/register/register_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/global/constant_values.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _loginUser() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final loginProvider = Provider.of<LoginProviders>(context, listen: false);

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      await loginProvider.loginWithEmailAndPasswordProvider(email, password);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast("An error occurred. Please try again.");
    }
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
                    SizedBox(height: 40.h),
                    Center(
                      child: Image.asset(
                        assetLogoImg,
                        width: 250.w,
                        height: 180.h,
                      ),
                    ),
                    SizedBox(height: 80.h),
                    CustomAuthTextField(
                      hintText: "Email",
                      icon: const Icon(Icons.email),
                      obSecure: false,
                      keyBoardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value) {
                        return RegExp(
                                // Regular expression to validate email
                                r"[a-z0-9!#%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                            .hasMatch(value!)
                            ? null
                            : "Please enter a valid email address";
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomAuthTextField(
                      hintText: "Password",
                      icon: IconButton(
                        icon: Icon(_isPasswordObscured
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscured = !_isPasswordObscured;
                          });
                        },
                      ),
                      obSecure: _isPasswordObscured,
                      keyBoardType: TextInputType.text,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 8) {
                          return 'Password must be more than 8 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
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
                    SizedBox(height: 50.h),
                    Center(
                      child: CustomButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _loginUser();
                          }
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

        // Show a loading overlay when isLoading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
