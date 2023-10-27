// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:zant/frontend/screens/authSceens/authWidgets/custom_auth_field.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/global/colors.dart';
import 'package:zant/server/home/profile_methods.dart';

class AddPhoneNumberScreen extends StatefulWidget {
  final String? phoneNumber;
  const AddPhoneNumberScreen({
    Key? key,
   required this.phoneNumber,
  }) : super(key: key);

  @override
  State<AddPhoneNumberScreen> createState() => _AddPhoneNumberScreenState();
}

class _AddPhoneNumberScreenState extends State<AddPhoneNumberScreen> {
  late final TextEditingController _phoneController ;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;


  @override
  void initState() {
  
     _phoneController =  TextEditingController(text:widget.phoneNumber );


    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  Future<void> _sendVerificationOtpCode() async {
    setState(() {
      _isLoading = true;
    });

    String phoneNumber = _phoneController.text.trim();
    String formattedNumber = "+92$phoneNumber";

    await ProfileMethods().verifyPhoneNumber(
      phoneNumber: formattedNumber,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const CustomAppBar(
            backgroundColor: appBarColor,
            title: "Enter phone number",
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50.h),
                CustomAuthTextField(
                  hintText: "Phone number",
                  icon: const Icon(Icons.phone),
                  obSecure: false,
                  keyBoardType: TextInputType.number,
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (value.length != 11) {
                      return 'Invalid phone number ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50.h),
                CustomButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _sendVerificationOtpCode();
                    }
                  },
                  width: 200,
                  height: 42,
                  text: "Done",
                  bgColor: Colors.blue,
                )
              ],
            ),
          ),
        ),

        // Show a loading overlay if isLoading is true
        if (_isLoading) const CustomLoadingOverlay(),
      ],
    );
  }
}
