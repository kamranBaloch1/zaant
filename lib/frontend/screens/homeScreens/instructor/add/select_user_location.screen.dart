// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:zant/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';
import 'package:zant/frontend/screens/homeScreens/instructor/add/select_subjects_screen.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_loading_overlay.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';

class SelectUserLocationScreen extends StatefulWidget {
  final String? selectedQualification;
  final String? phoneNumber;
  final int? feesPerHour;
  const SelectUserLocationScreen({
    Key? key,
    this.selectedQualification,
    this.phoneNumber,
    this.feesPerHour,
  }) : super(key: key);

  @override
  _SelectUserLocationScreenState createState() =>
      _SelectUserLocationScreenState();
}

class _SelectUserLocationScreenState extends State<SelectUserLocationScreen> {
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Simulate loading delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _moveToNextScreenMethod() async {
    String address = _addressController.text.trim();

    if (address.isNotEmpty) {
      Get.to(() => SelectSubjectsScreen(
          address: address,
          selectedQualification: widget.selectedQualification,
          phoneNumber: widget.phoneNumber,
          feesPerHour: widget.feesPerHour));
    } else {
      showCustomToast("please write your address");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            backgroundColor: appBarColor,
            title: "Please write your full address",
          ),
          body: Column(children: [
            SizedBox(
              height: 50.h,
            ),
            homeCustomTextField(
                controller: _addressController,
                labelText: "Add your address",
                icon: Icons.house,
                keyBoardType: TextInputType.text),
            SizedBox(
              height: 70.h,
            ),
            CustomButton(
              onTap: _isLoading ? null : _moveToNextScreenMethod,
              width: 200,
              height: 40,
              text: "Next",
              bgColor: Colors.blue,
            )
          ]),
        ),

        // Show a loading overlay if loading is true
        if (_isLoading) const CustomLoadingOverlay()
      ],
    );
  }
}
