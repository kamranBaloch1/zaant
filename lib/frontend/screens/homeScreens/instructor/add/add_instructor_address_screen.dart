// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:zaanth/frontend/screens/homeScreens/homeWidgets/custom_home_text_field.dart';
import 'package:zaanth/frontend/screens/homeScreens/instructor/add/syllabus_types_screen.dart';
import 'package:zaanth/frontend/screens/widgets/custom_appbar.dart';
import 'package:zaanth/frontend/screens/widgets/custom_button.dart';
import 'package:zaanth/frontend/screens/widgets/custom_toast.dart';
import 'package:zaanth/global/colors.dart';
import 'package:zaanth/sharedprefences/userPref.dart';

class AddInstructorAddressScreen extends StatefulWidget {
  final String? selectedQualification;
  final String? phoneNumber;
  final int? feesPerMonth;
   final String? tuitionType;
  final String? teachingExperience;
  final String? degreeCompletionStatus;
  const AddInstructorAddressScreen({
    Key? key,
    required this.selectedQualification,
    required this.phoneNumber,
    required this.feesPerMonth, 
    required this.teachingExperience, 
    required this.tuitionType, 
    required this.degreeCompletionStatus, 
  }) : super(key: key);

  @override
  State<AddInstructorAddressScreen> createState() =>
      _AddInstructorAddressScreenState();
}

class _AddInstructorAddressScreenState
    extends State<AddInstructorAddressScreen> {
  final TextEditingController _address = TextEditingController();

  String? userCity;

  @override
  void initState() {
     userCity = UserPreferences.getCity();
    super.initState();
  }

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          backgroundColor: appBarColor, title: "Add your Address"),
      body: Form(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Note : Please add your full adresss ",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black45),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Example : Areaname/BuildingName/flat No",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black45),
            ),
            SizedBox(
              height: 30.h,
            ),
             Text(
              "Your City ($userCity)",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
             SizedBox(
              height: 50.h,
            ),
            HomeCustomTextField(
                controller: _address,
                labelText: "Write your address",
                icon: Icons.home,
                keyBoardType: TextInputType.text),
            SizedBox(
              height: 150.h,
            ),
            CustomButton(
                onTap: () {
                  String address = _address.text.trim();

                  if (address.isEmpty) {
                    showCustomToast("please write your address");
                    return;
                  }

                  Get.to(() => SyllabusTypeScreen(
                      selectedQualification: widget.selectedQualification,
                      phoneNumber: widget.phoneNumber,
                      feesPerMonth: widget.feesPerMonth,
                      address: address,
                      teachingExperience: widget.teachingExperience,
                      tuitionType: widget.tuitionType,
                      degreeCompletionStatus: widget.degreeCompletionStatus,
                      ));
                },
                width: 200,
                height: 40,
                text: "Next",
                bgColor: Colors.blue)
          ],
        ),
      ),
    );
  }
}
