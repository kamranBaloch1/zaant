import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zant/frontend/screens/homeScreens/homeWidgets/pick_subejcts_dropdown.dart';
import 'package:zant/frontend/screens/homeScreens/profile/screens/subject/new_subject_days.dart';
import 'package:zant/frontend/screens/widgets/custom_appbar.dart';
import 'package:zant/frontend/screens/widgets/custom_button.dart';
import 'package:zant/frontend/screens/widgets/custom_toast.dart';
import 'package:zant/global/colors.dart';

class AddNewSubjectForInstructorScreen extends StatefulWidget {
  const AddNewSubjectForInstructorScreen({super.key});

  @override
  State<AddNewSubjectForInstructorScreen> createState() =>
      _AddNewSubjectForInstructorScreenState();
}

class _AddNewSubjectForInstructorScreenState
    extends State<AddNewSubjectForInstructorScreen> {

void _moveToNextScreenMethod() async {
    if (_selectedSubjects.isNotEmpty) {
      Get.to(() => NewSubjectDaysScreen(
          selectedSubjects: _selectedSubjects,
      ));
    } else {
      showCustomToast("Please select at least one subject.");
    }
  }



  List<String> _selectedSubjects = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(backgroundColor: appBarColor, title: 'Add new Subject'),
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: PickSubjectsDropdown(
              selectedSubjects: _selectedSubjects,
              onChanged: (selectedSubjects) {
                setState(() {
                  _selectedSubjects = selectedSubjects;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
            child: CustomButton(
              onTap:  _moveToNextScreenMethod,
              width: 200,
              height: 40,
              text: "Next",
              bgColor: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
