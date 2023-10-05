// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/profile/profile_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/server/home/profile_methods.dart';

class NumberOtpVerifyScreen extends StatefulWidget {
  final String? verificationId;
  final String? phoneNumber;

  const NumberOtpVerifyScreen({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _NumberOtpVerifyScreenState createState() => _NumberOtpVerifyScreenState();
}

class _NumberOtpVerifyScreenState extends State<NumberOtpVerifyScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set focus on the first box initially
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> verifyingTheOtp(String otp) async {
    setState(() {
      _isLoading = true;
    });
    await ProfileMethods()
        .verifyOTP(
            phoneNumberVerificationId: widget.verificationId,
            otp: otp,
            phoneNumber: widget.phoneNumber)
        .then((isVerified) {
      if (isVerified) {
        // Navigate to the next screen after successful OTP verification
        Get.offAll(() => const ProfileScreen());
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
              backgroundColor: appBarColor, title: "Enter OTP Code"),
          body: Padding(
            padding:  EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 50.w,
                      height: 60.h,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            // Move focus to the next box if available
                            _focusNodes[index].unfocus();
                            _focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            // Move focus to the previous box if available
                            _focusNodes[index].unfocus();
                            _focusNodes[index - 1].requestFocus();
                          }

                          if (isOtpFilled()) {
                            // When all OTP boxes are filled, verify the OTP
                            String otp = _otpControllers
                                .map((controller) => controller.text)
                                .join();
                            verifyingTheOtp(otp);
                          }
                        },
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24.sp,
                            color: Colors.black), // Text color is set to black
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // showing a loading bar

        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }

  bool isOtpFilled() {
    // Check if all OTP boxes are filled
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }
}
