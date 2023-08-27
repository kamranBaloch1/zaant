import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/auth/login_providers.dart';
import 'package:zant/frontend/screens/authSceens/login/login_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/authSceens/authWidgets/custom_auth_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final loginProviders = Provider.of<LoginProviders>(context, listen: false);

    String email = _emailController.text.trim();
    loginProviders.resetUserPasswordProvider(email).then((value) => {
      _emailController.clear(),
      setState(() {
        _isLoading = false;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 50.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter your email to reset your password",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 100.h),
                      CustomAuthTextField(
                        hintText: "Email address",
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
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 40.h, horizontal: 60.w),
                        child: CustomButton(
                          bgColor: Colors.blue,
                          text: "Submit",
                          width: 200,
                          height: 40,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _resetPassword();
                            }
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offAll(() => const LoginScreen());
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 3.w, top: 100.h),
                          alignment: Alignment.center,
                          child: const Text(
                            "Back to login screen?",
                            style: TextStyle(
                              color: Colors.black87,
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
        ),

        // Show a loading overlay if isLoading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
