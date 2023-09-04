// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zant/frontend/providers/home/instructor_provider.dart';

import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';

class PhoneOTPVerificationScreen extends StatefulWidget {
  final String verificationId;
  final List<String> selectedSubjects;
  final String? selectedQualification;
  final int? phoneNumber;
  final int? feesPerHour;
  final Map<String, Map<String, Map<String, String>>> availableTimings;
  const PhoneOTPVerificationScreen({
    Key? key,
    required this.verificationId,
    required this.selectedSubjects,
    required this.selectedQualification,
    required this.phoneNumber,
    required this.feesPerHour,
    required this.availableTimings,
  }) : super(key: key);

  @override
  _PhoneOTPVerificationScreenState createState() =>
      _PhoneOTPVerificationScreenState();
}

class _PhoneOTPVerificationScreenState
    extends State<PhoneOTPVerificationScreen> {
  bool _isLoading = false;

  List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  List<FocusNode> focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  

  Future<void> _verifyPhoneNumber(String value) async {
     
    try {
      setState(() {
        _isLoading = true;
      });
      final instructorProvider =
          Provider.of<InstructorProviders>(context, listen: false);
     
    
      await instructorProvider.addInstructorProvider(
          phoneNumber: widget.phoneNumber!,
          qualification: widget.selectedQualification!,
          subjects: widget.selectedSubjects,
          feesPerHour: widget.feesPerHour!,
          availableTimings: widget.availableTimings,
          verificationCode: value,
          verificationId: widget.verificationId);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast("Error verifying the otp $e");
    }
  }

  bool areAllOTPFilled() {
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: ReusableAppBar(
              backgroundColor: appBarColor, title: "OTP Verification"),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Enter the 6-digit OTP sent to your phone',
                  style: TextStyle(fontSize: 18.sp, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => _buildOTPTextField(controllers[index], index),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                CustomButton(
                  onTap: () {
                    if (areAllOTPFilled()) {
                      // All OTP fields are filled, proceed with verification
                      final otp = controllers
                          .map((controller) => controller.text)
                          .join();
                      _verifyPhoneNumber(otp);
                    } else {
                      // Display an error message or take appropriate action if fields are not filled
                      showCustomToast("Please enter the complete OTP");
                    }
                  },
                  width: 200,
                  height: 40,
                  text: "Verify",
                  bgColor: Colors.blue,
                )
              ],
            ),
          ),
        ),

        // Show loading overlay if _isLoading is true
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }

  Widget _buildOTPTextField(TextEditingController controller, int index) {
    return GestureDetector(
      onTap: () {
        if (index > 0) {
          controllers[index - 1].clear();
          focusNodes[index - 1].requestFocus();
        }
      },
      child: Container(
        width: 60.w, // Increase the box size
        height: 60.h, // Increase the box size
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: TextField(
            style: const TextStyle(color: Colors.black),
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            focusNode: focusNodes[index],
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                focusNodes[index + 1].requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
