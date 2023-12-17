// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zaanth/frontend/providers/home/instructor_provider.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/add/add_instructor_address_screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zaanth/global/colors.dart';


class PhoneNumberOTPScreen extends StatefulWidget {
  final String? verificationId;
  final String? phoneNumber;
  final String? selectedQualification;
  final int? feesPerMonth;
   final String? tuitionType;
  final String? teachingExperience;
  final String? degreeCompletionStatus;

  const PhoneNumberOTPScreen({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
    required this.selectedQualification,
    required this.feesPerMonth,
    required this.teachingExperience,
    required this.tuitionType,
    required this.degreeCompletionStatus,
  }) : super(key: key);

  @override
  _PhoneNumberOTPScreenState createState() => _PhoneNumberOTPScreenState();
}

class _PhoneNumberOTPScreenState extends State<PhoneNumberOTPScreen> {
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

  void verifyingTheOtp(String otp) async {
    setState(() {
      _isLoading = true;
    });
    final instructorProvider = Provider.of<InstructorProviders>(context,listen: false);
    await instructorProvider
        .verifyOTPProvider(
            phoneNumberVerificationId: widget.verificationId,
            otp: otp,
            phoneNumber: widget.phoneNumber)
        .then((isVerified) {
      if (isVerified) {
        // Navigate to the next screen after successful OTP verification
            
        Get.offAll(() => AddInstructorAddressScreen(
            selectedQualification: widget.selectedQualification,
            phoneNumber: widget.phoneNumber,
            feesPerMonth: widget.feesPerMonth,
            teachingExperience: widget.teachingExperience,
            tuitionType: widget.tuitionType,
            degreeCompletionStatus: widget.degreeCompletionStatus,
            
            ));
       
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
          appBar: const CustomAppBar(
              backgroundColor: appBarColor, title: "Enter OTP Code"),
          body: Padding(
            padding: EdgeInsets.all(16.w),
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
